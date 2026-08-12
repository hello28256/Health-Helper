# 部署指南

本文档覆盖生产环境部署：环境变量、生产镜像、Postgres 安全、HTTPS / 反向代理、监控。

---

## 1. 环境变量

所有环境变量在 `src/utils/env.ts` 用 Zod 校验，缺失或不合法会让进程**启动失败**（不会跑半残）。

### 必填

| 变量 | 说明 | 示例 |
|------|------|------|
| `NODE_ENV` | `production` / `development` / `test` | `production` |
| `PORT` | 监听端口 | `3000` |
| `DATABASE_URL` | PostgreSQL 连接串（含 `?schema=public`） | `postgresql://user:pwd@host:5432/health_helper?schema=public` |
| `JWT_ACCESS_SECRET` | HS256 签名密钥，**至少 16 字符**，必须用 `openssl rand -hex 32` | `68a0bb68...` |
| `JWT_REFRESH_SECRET` | 同上，**与 access 不同**（泄露一个不污染另一个） | `7d2f8a9b...` |

### 推荐配置

| 变量 | 默认 | 生产建议 |
|------|------|---------|
| `JWT_ACCESS_TTL` | `15m` | `15m`（短一点更好；refresh 接管续期） |
| `JWT_REFRESH_TTL` | `7d` | `7d` ~ `30d`；可按风险接受度调 |
| `BCRYPT_ROUNDS` | `12` | `12`（≈250ms/hash，平衡安全与 CPU） |
| `CORS_ORIGINS` | `""` | 逗号分隔；空 = 全部允许（仅调试） |
| `RATE_LIMIT_WINDOW_MS` | `60000` | `60000`（每分钟） |
| `RATE_LIMIT_MAX_REQUESTS` | `100` | `100`~`300`；按真实流量调 |
| `LOG_LEVEL` | `info` | `info`（生产） / `debug`（排障） |

### 可选（AI 功能）

| 变量 | 说明 |
|------|------|
| `ANTHROPIC_API_KEY` | 启用 Anthropic Claude provider；优先使用 |
| `ANTHROPIC_MODEL` | 默认 `claude-sonnet-5` |
| `OPENAI_API_KEY` | 启用 OpenAI provider；Claude key 不存在时回退 |
| `OPENAI_MODEL` | 默认 `gpt-4o` |

**两个 key 都不设** → `/api/chat/messages` 返回 `503 AI_DISABLED`（不静默失败）。

### 生成 JWT 密钥

```bash
openssl rand -hex 32   # 64 字符 hex
```

---

## 2. 生产部署

### 步骤 A：编译 + 启动

```bash
# 1. 装依赖
npm ci

# 2. 生成 Prisma client
npx prisma generate

# 3. 跑迁移（**不会**自动改字段；只跑未执行的 migration）
npx prisma migrate deploy

# 4. （可选）种子数据（仅首次部署新库时跑）
npm run db:seed

# 5. 编译 TS
npm run build

# 6. 起服务
NODE_ENV=production node dist/index.js
```

### 步骤 B：用 PM2（推荐）

`ecosystem.config.js`：

```js
module.exports = {
  apps: [{
    name: 'health-helper-api',
    script: './dist/index.js',
    instances: 'max',          // 按 CPU 核数起多进程
    exec_mode: 'cluster',
    max_memory_restart: '512M',
    env: {
      NODE_ENV: 'production',
    },
  }],
};
```

```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup    # 配开机自启
```

### 步骤 C：systemd

`/etc/systemd/system/health-helper.service`：

```ini
[Unit]
Description=Health Helper API
After=network.target postgresql.service

[Service]
Type=simple
User=healthhelper
WorkingDirectory=/opt/health-helper
EnvironmentFile=/opt/health-helper/.env
ExecStart=/usr/bin/node dist/index.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now health-helper
sudo systemctl status health-helper
```

---

## 3. Postgres 生产配置

### 用户最小权限

不要用 `postgres` 超级用户跑应用。创建专用用户：

```sql
CREATE USER health_helper_app WITH PASSWORD 'STRONG_RANDOM_PASSWORD';
GRANT CONNECT ON DATABASE health_helper TO health_helper_app;
GRANT USAGE ON SCHEMA public TO health_helper_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO health_helper_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO health_helper_app;
-- 未来 migration 自动建的表也用同样权限
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO health_helper_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO health_helper_app;
```

### 备份

```bash
# 全量备份
pg_dump -Fc -d health_helper -f /backup/health_helper_$(date +%Y%m%d).dump

# 恢复
pg_restore -d health_helper /backup/health_helper_20260812.dump
```

### 连接池

应用侧 Prisma 已自带连接池（默认 `num_physical_cpus * 2 + 1`）。  
如果 Postgres 部署在远端，可在 Prisma 连接串加 `?connection_limit=10&pool_timeout=20`。

---

## 4. 反向代理 + HTTPS

**不要让 Express 直接对外暴露 3000 端口** —— 用 Nginx/Caddy 处理 HTTPS、限流、静态缓存（如果有）。

### Nginx 示例

```nginx
server {
  listen 443 ssl http2;
  server_name api.example.com;

  ssl_certificate     /etc/letsencrypt/live/api.example.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/api.example.com/privkey.pem;

  # 限流（再叠一层保险）
  limit_req_zone $binary_remote_addr zone=api:10m rate=30r/s;

  location / {
    limit_req zone=api burst=60 nodelay;
    proxy_pass http://127.0.0.1:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 60s;
  }

  # 不缓存 API
  add_header Cache-Control no-store;
}
```

### Caddy 示例

```caddyfile
api.example.com {
  reverse_proxy 127.0.0.1:3000 {
    header_up Host {host}
    header_up X-Real-IP {remote}
  }
}
```

---

## 5. Docker 部署

### 当前 `docker-compose.yml` 用途

仓库里的 compose 是**开发用**：volume 挂源码、`tsx watch` 热重载、迁移自动跑。  
**生产部署不要直接用**，应单独写生产 compose 或直接用上节的 PM2/systemd。

### 生产 Dockerfile 模板（按需新建 `docker/Dockerfile.prod`）

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY prisma ./prisma
RUN npm ci
RUN npx prisma generate
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY prisma ./prisma
EXPOSE 3000
USER node
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/index.js"]
```

构建/跑：

```bash
docker build -f docker/Dockerfile.prod -t health-helper-api:0.1.0 .
docker run -d \
  --name health-helper-api \
  --restart unless-stopped \
  -p 3000:3000 \
  --env-file .env.production \
  health-helper-api:0.1.0
```

---

## 6. 监控 + 健康检查

### `/health` 端点

```bash
curl http://localhost:3000/health
# {"status":"ok","env":"production","ts":"2026-08-12T..."}
```

### k8s probe 模板

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 10
  periodSeconds: 30
readinessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10
```

### 日志

- 业务日志走 `src/utils/logger.ts`，JSON-ish 行格式，包含 timestamp + level + context
- 建议接入 Loki / ELK / Datadog
- 错误堆栈会被 logger 自动捕获（见 `errorHandler`）

### 推荐指标

- 请求 QPS / P50 / P95 / P99 latency
- 4xx / 5xx 比例
- 活跃 refresh token 数（数据库 `SELECT COUNT(*) FROM refresh_tokens WHERE revoked_at IS NULL AND expires_at > NOW()`）
- AI upstream 失败率（502 数）

---

## 7. 安全清单

生产前确认：

- [ ] `JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` 用 `openssl rand -hex 32` 生成，**不要提交进 git**
- [ ] `.env` 在 `.gitignore` 中（仓库已配）
- [ ] Postgres 用专用应用用户，不用 `postgres` 超级用户
- [ ] Postgres 监听端口（5432）**只在内网开放**，或用 Unix socket
- [ ] 反向代理前置，处理 HTTPS、限流、IP 白名单
- [ ] `CORS_ORIGINS` 显式列出允许的前端域名，**不要留空**（空 = 全部允许）
- [ ] `BCRYPT_ROUNDS=12` 保持默认
- [ ] refresh token 用 SHA-256 哈希入库（已实现，见 `userService.hashToken`）
- [ ] `/api/docs` 在生产是否保留？建议保留内部访问（反向代理加 IP 白名单），关闭公网
- [ ] AI provider key 不在前端出现，所有调用走后端
- [ ] 日志脱敏：user 输入的 `content` / `note` 可能含 PAI，不要原样打到日志（当前 logger 会打 context 但不会打完整请求 body）

---

## 8. 故障排查

### `prisma migrate deploy` 失败

```bash
# 检查当前 migration 状态
npx prisma migrate status

# 如果 schema drift，需要先 resolve：开发环境跑 prisma migrate dev 生成新 migration，
# 然后生产再 prisma migrate deploy
```

### `Invalid JWT secret` 启动失败

`JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` 至少 16 字符。生产建议 32+。

### `ECONNREFUSED 127.0.0.1:5432`

Postgres 没起来，或 `DATABASE_URL` 配错。Docker 容器内用 `postgres` 作为主机名（不是 `localhost`）。

### `503 AI_DISABLED`

`ANTHROPIC_API_KEY` 和 `OPENAI_API_KEY` 都为空。按需配至少一个（推荐 Anthropic Claude）。

### `429 RATE_LIMITED`

`RATE_LIMIT_MAX_REQUESTS` 太小，或有爬虫。按需调大，或在反代层加 IP 白名单。

### Refresh token 频繁 401

- 客户端时钟漂移 → 检查设备时间
- `JWT_REFRESH_TTL` 太短
- 同一端多次登录触发 rotation（每次 login 会撤销旧 token），属正常
