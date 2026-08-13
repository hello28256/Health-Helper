# Health Helper API

跨端健康助手统一后端（iOS / Android / Web 共用账号、数据互通）。

> **文档导航**
> - 架构设计：[`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md)
> - API 文档：[`docs/API.md`](./docs/API.md) · 在线 Swagger UI：启动后访问 `http://localhost:3000/api/docs`
> - 部署指南：[`docs/DEPLOY.md`](./docs/DEPLOY.md)
> - **Web 前端**：[`web/`](./web/) · React 18 + TS + Vite + Tailwind · 移动/桌面响应式 · 调用本后端 API

---

## 功能概览

| 模块 | 端点前缀 | 说明 |
|------|---------|------|
| 用户系统 | `/api/auth`, `/api/users` | 注册/登录、JWT 多端会话、跨设备数据同步 |
| 运动 + 步数 | `/api/exercises` | MET 公式算卡路里（服务端权威）、步数 max-value 策略 |
| 饮食 + 营养 | `/api/diet` | 89+ 食物营养库、按需记录、服务端计算实际摄入 |
| 心理健康 | `/api/mood`, `/api/chat` | 情绪记录 + 趋势、AI 对话（含医疗免责声明） |
| API 文档 | `/api/docs` | OpenAPI 3.0 + Swagger UI |
| 健康检查 | `/health` | 探活 |

### 核心特性

- **跨端数据同步**：一个账号在 iOS/Android/Web 看到完全相同的数据
- **服务端权威计算**：卡路里和营养摄入由服务端按公式计算，**不信任客户端传入值**
- **多端独立会话**：每个 `deviceId` 有独立 refresh token，互不干扰
- **Refresh token rotation**：每次 refresh 撤销旧 token 并签发新的，泄露可检测
- **医疗合规**：AI 对话强制带医疗免责声明，无 API key 时返回 `503 AI_DISABLED` 而非静默失败

---

## 技术栈

- **运行时**：Node.js 20+ / TypeScript 5
- **Web**：Express 4 + Zod 校验 + Helmet + CORS + express-rate-limit
- **数据库**：PostgreSQL 15 + Prisma ORM
- **认证**：JWT (HS256) access + refresh，Bcrypt cost 12 密码哈希，refresh token 存 SHA-256
- **AI**：Anthropic Claude / OpenAI（可选，缺失则禁用 chat endpoint）
- **测试**：Jest 29 + Supertest 7 + ts-jest（57 单元 + 7 集成 = **64 测试**）
- **质量**：ESLint airbnb-typescript + Prettier 100 字符
- **部署**：Docker / Docker Compose / 任意 Node 20+ 主机

---

## 项目结构

```
Health-Helper/
├── prisma/
│   ├── schema.prisma          # 10 张表（User/Exercise/Step/Food/Diet/Mood/ChatLog...）
│   ├── migrations/            # Prisma 迁移
│   ├── seed.ts                # 9 运动类型 + 中文安全提示
│   └── seed-foods.ts          # 89 食物 × 8 类别
├── src/
│   ├── api/                   # Express 路由
│   │   ├── auth.ts            #   /api/auth
│   │   ├── users.ts           #   /api/users
│   │   ├── exercises.ts       #   /api/exercises (含 steps)
│   │   ├── diet.ts            #   /api/diet
│   │   ├── mood.ts            #   /api/mood
│   │   ├── chat.ts            #   /api/chat
│   │   ├── docs.ts            #   /api/docs (Swagger UI)
│   │   ├── app.ts             #   Express 装配
│   │   └── middlewares/       #   auth / validate
│   ├── services/              # 业务逻辑层（按 CLAUDE.md 分层）
│   │   ├── userService.ts     #   注册/登录/refresh（bcrypt + JWT）
│   │   ├── calorie.ts         #   纯函数：MET × weight × duration
│   │   ├── exerciseService.ts #   运动 + 步数（max-value 策略）
│   │   ├── dietService.ts     #   食物搜索/记录/汇总
│   │   ├── moodService.ts     #   情绪记录 + 趋势聚合
│   │   ├── chatService.ts     #   AI 对话（含医疗免责声明）
│   │   └── aiProvider.ts      #   Anthropic/OpenAI/Disabled 适配
│   ├── docs/
│   │   └── openapi.ts         # OpenAPI 3.0 规范（16 paths）
│   ├── models/
│   │   └── prisma.ts          # Prisma client 单例
│   ├── utils/                 # env / logger / errors / jwt
│   └── index.ts               # 入口
├── tests/
│   ├── integration.test.ts    # 7 个 supertest E2E（真实 Postgres）
│   ├── *.test.ts              # 57 单元测试
│   └── setup.ts               # 加载 .env、屏蔽 AI key
├── docs/
│   ├── ARCHITECTURE.md        # 架构图 + 数据模型 + 安全
│   ├── API.md                 # 人类可读 API 文档
│   └── DEPLOY.md              # 部署 + 生产注意事项
├── docker-compose.yml         # Postgres + API
└── package.json
```

---

## 快速开始

### 方式 A：Docker Compose（最省事）

```bash
cp .env.example .env
# 至少修改 JWT_ACCESS_SECRET / JWT_REFRESH_SECRET

docker compose up -d              # 起 Postgres + 跑迁移 + 起 API
docker compose logs -f api        # 看 API 日志
```

API 跑在 `http://localhost:3000`，Swagger UI 在 `http://localhost:3000/api/docs`。

### 方式 B：本地 Node（推荐日常开发）

```bash
# 1. 仅起 Postgres
docker compose up -d postgres

# 2. 装依赖 + 初始化 DB
npm install
npm run prisma:migrate           # 开发期迁移
npm run db:seed                  # 9 运动 + 89 食物

# 3. 起 API（热重载）
npm run dev
```

### 第一次注册

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "alice@example.com",
    "password": "strong-password-123",
    "deviceId": "my-iphone"
  }'
```

完整 API 说明见 [`docs/API.md`](./docs/API.md)。

---

## 常用命令

```bash
# 数据库
npm run prisma:migrate          # 开发期迁移（带交互）
npm run prisma:deploy           # 生产部署迁移
npm run prisma:studio           # 打开 Prisma Studio (http://localhost:5555)
npm run db:seed                 # 跑种子数据

# 开发
npm run dev                     # 开发（tsx watch 热重载）
npm run build && npm start      # 生产（先编译再跑）

# 测试 & 质量
npm test                        # 单次（57 单元 + 7 集成）
npm run test:watch              # 监听
npm run test:coverage           # 覆盖率报告
npm run typecheck               # tsc --noEmit
npm run lint                    # ESLint
npm run lint:fix                # ESLint 自动修复
npm run format                  # Prettier
```

---

## 数据库模型概览

10 张表，详见 [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) §4。

| 表 | 用途 |
|----|------|
| `users` | 用户基础信息（email、passwordHash、heightCm、weightKg） |
| `refresh_tokens` | 多端 refresh token 哈希（deviceId 维度）+ 过期/撤销 |
| `exercise_types` | 运动类型字典（MET、注意事项） |
| `exercise_records` | 运动记录（calories 服务端算） |
| `daily_steps` | 每日步数（max-value 策略） |
| `food_nutrients` | 食物营养库（只读参考数据） |
| `diet_records` | 饮食记录（servings + foodId） |
| `mood_records` | 情绪记录（mood enum + score 1-10 + note） |
| `chat_logs` | AI 对话历史（user + assistant） |

---

## 测试覆盖

```
Test Suites: 8 passed, 8 total
Tests:       64 passed, 64 total
```

- **单元测试（57）**：所有 service 层纯逻辑
  - `userService.test.ts`（注册/登录/refresh/logout/profile）
  - `calorie.test.ts`（MET 公式、步数距离公式、边界）
  - `exerciseService.test.ts`（创建/列表、max-value 步数）
  - `dietService.test.ts`（搜索/记录/汇总/服务端摄入计算）
  - `moodService.test.ts`（记录/列表/趋势聚合）
  - `chatService.test.ts`（AI 错误处理、医疗免责声明、provider 切换）
  - `app.test.ts`（健康检查 + 404）
- **集成测试（7）**：supertest + 真实 Postgres
  - 完整用户旅程 + 错误路径 + 跨端数据一致性

集成测试需要本地有 Postgres（参见快速开始 B 方式）。

---

## 部署

详见 [`docs/DEPLOY.md`](./docs/DEPLOY.md)。核心点：

- **环境变量**：`DATABASE_URL`、`JWT_ACCESS_SECRET`、`JWT_REFRESH_SECRET`、`JWT_ACCESS_TTL`、`JWT_REFRESH_TTL`、`BCRYPT_ROUNDS`、`CORS_ORIGINS`、可选 `ANTHROPIC_API_KEY` / `OPENAI_API_KEY`
- **生产前置**：`npm run prisma:deploy` + `npm run build`
- **反向代理**：强烈建议前置 Nginx/Caddy 处理 HTTPS + 限流
- **监控**：`/health` 端点可直接给 k8s readinessProbe 用

---

## ⚠️ 后端代码改动后

按你的全局规则：**修改后端代码后需要重启服务才能生效**。

- 开发模式：`npm run dev`（tsx watch 自动热重载大部分改动，但 **Prisma schema 改动需手动重启**）
- Docker：`docker compose restart api`
- 生产：`pm2 reload ecosystem.config.js` 或类似

---

## License

MIT
