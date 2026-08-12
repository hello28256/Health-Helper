# Health Helper API

跨端健康助手统一后端（iOS / Android / Web 共用）。

> 详细架构、数据模型、API 契约见 [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md)。

---

## 技术栈

- Node.js 20+ / TypeScript 5
- Express 4 + Zod 校验
- PostgreSQL 15 + Prisma ORM
- JWT (Access + Refresh) 多端会话
- Jest + Supertest 单元 / 集成测试
- ESLint airbnb + Prettier 100
- Docker Compose 一键起 Postgres + API

---

## 项目结构

```
Health-Helper/
├── prisma/                  # Prisma schema + migrations
├── src/
│   ├── api/                 # Express 路由 + middleware
│   ├── services/            # 业务逻辑（按 CLAUDE.md 分层）
│   ├── models/              # 数据访问（Prisma client 等）
│   └── utils/               # env / logger / errors
├── tests/                   # Jest 测试
├── docs/                    # 架构 / API 文档
├── docker/                  # Dockerfile
├── docker-compose.yml       # Postgres + API 一键启动
└── package.json
```

---

## 快速开始

### 1. 启动 Postgres + API

```bash
# 首次启动
docker-compose up -d

# 查看日志
docker-compose logs -f api
```

API 跑在 `http://localhost:3000`。

### 2. 本地开发（不开 Docker 的 API 容器）

```bash
# 复制环境变量
cp .env.example .env
# 编辑 .env，至少修改 JWT_ACCESS_SECRET / JWT_REFRESH_SECRET

# 安装依赖
npm install

# 仅启动 Postgres（用 Docker）
docker-compose up -d postgres

# 运行数据库迁移
npm run prisma:migrate

# 启动 API（热重载）
npm run dev
```

### 3. 测试

```bash
npm test                 # 单次运行
npm run test:watch       # 监听模式
npm run test:coverage    # 覆盖率
```

### 4. 代码质量

```bash
npm run typecheck        # tsc --noEmit
npm run lint             # ESLint
npm run lint:fix         # 自动修复
npm run format           # Prettier
```

---

## 已实现 vs 待实现

| 模块 | 状态 | 说明 |
|------|------|------|
| 项目骨架 | ✅ | 本次提交 |
| 健康检查 + 错误中间件 | ✅ | `/health`、404、AppError 体系 |
| Prisma schema | ✅ | 10 张表，对应 ARCHITECTURE.md §4 |
| 用户系统（注册/登录/JWT） | 🔜 Task #3 | |
| 运动记录 + 卡路里 + 步数 | 🔜 Task #4 | |
| 饮食 + 食物营养 | 🔜 Task #5 | |
| 情绪日记 + AI 对话 | 🔜 Task #6 | |

---

## 常用命令速查

```bash
# 数据库
npm run prisma:migrate          # 开发期迁移（带交互）
npm run prisma:deploy           # 生产部署
npm run prisma:studio           # 打开 Prisma Studio (http://localhost:5555)
npm run db:seed                 # 跑种子数据

# 启动
npm run dev                     # 开发（tsx watch）
npm run build && npm start      # 生产

# 测试 & 质量
npm test
npm run typecheck
npm run lint
```

---

## ⚠️ 后端代码改动后

按你的全局规则：**修改后端代码后需要重启服务才能生效**。

- 开发模式：`npm run dev` 会自动热重载，但 Prisma schema 改动需重启。
- Docker：`docker-compose restart api`。
