# Health-Helper 架构设计文档

> 版本：v0.1 · 最后更新：2026-08-12

---

## 1. 项目目标

跨端健康助手 App，覆盖：
- **移动端**：iOS / Android（共用一套代码，React Native 或 Flutter）
- **Web 端**：浏览器（响应式 Web）
- **后端**：统一 REST API + 数据持久化

**核心承诺**（来自需求 #1）：
> 一个账号在不同端看到的数据一致。

---

## 2. 系统架构总览

```
┌─────────────────────────────────────────────────────────────┐
│                        客户端 (Clients)                       │
│                                                              │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│   │ iOS App      │    │ Android App  │    │ Web App      │  │
│   │ (RN/Flutter) │    │ (RN/Flutter) │    │ (React)      │  │
│   └──────┬───────┘    └──────┬───────┘    └──────┬───────┘  │
│          │                   │                   │          │
│          │  计步器/陀螺仪    │  计步器/陀螺仪    │  浏览器   │
│          └───────────────────┴───────────────────┘          │
│                              │                               │
└──────────────────────────────┼───────────────────────────────┘
                               │ HTTPS (JWT Auth)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    后端 API Gateway                          │
│                                                              │
│   ┌────────────────────────────────────────────────────┐   │
│   │  Express / Fastify (Node.js + TypeScript)          │   │
│   │  ├─ /api/auth         注册、登录、刷新 token       │   │
│   │  ├─ /api/users/me     用户资料                     │   │
│   │  ├─ /api/exercises    运动记录 + 卡路里            │   │
│   │  ├─ /api/steps        步数上报/聚合                │   │
│   │  ├─ /api/diet         食物搜索 + 饮食记录          │   │
│   │  ├─ /api/mood         情绪日记                     │   │
│   │  └─ /api/chat         AI 心理对话（LLM 代理）      │   │
│   └────────────────────────────────────────────────────┘   │
│                              │                               │
│   ┌──────────────┐  ┌────────┴────────�  ┌──────────────┐  │
│   │  Auth        │  │  Services       │  │  Repositories│  │
│   │  Middleware  │  │  (业务逻辑)      │  │  (数据访问)   │  │
│   └──────────────┘  └─────────────────┘  └──────┬───────┘  │
│                                                  │          │
└──────────────────────────────────────────────────┼──────────┘
                                                   │
                                                   ▼
                                ┌──────────────────────────────┐
                                │  PostgreSQL 15+              │
                                │  ├─ users                    │
                                │  ├─ exercises / steps         │
                                │  ├─ food_nutrients (大表)     │
                                │  ├─ diet_records             │
                                │  └─ mood_records / chat_logs │
                                └──────────────────────────────┘
                                          │
                                          │ (异步任务)
                                          ▼
                                ┌──────────────────────────────┐
                                │  LLM Provider (Anthropic/    │
                                │  OpenAI) — 仅 /api/chat 调用 │
                                └──────────────────────────────┘
```

---

## 3. 技术栈

| 层 | 选型 | 理由 |
|----|------|------|
| 后端语言 | Node.js + TypeScript | 与用户偏好一致；前后端共享类型；生态成熟 |
| Web 框架 | Express 5 | 学习曲线低、中间件丰富 |
| ORM | Prisma | 类型安全；迁移工具完善；schema 即文档 |
| 数据库 | PostgreSQL 15 | JSONB、全文检索（食物搜索）、时序数据友好 |
| 认证 | JWT (Access + Refresh) | 无状态；天然支持多端 |
| 校验 | Zod | TypeScript 优先；运行时 + 类型双重校验 |
| 测试 | Jest + Supertest | 用户偏好 |
| Lint/Format | ESLint airbnb + Prettier 100 | 用户偏好 |
| 容器 | Docker Compose | 本地一键启动 Postgres |
| 移动端（后续） | React Native 或 Flutter | 单代码库覆盖 iOS + Android |
| Web 端（后续） | React + Vite + TanStack Query | 与后端类型共享 |

> **关于 LLM**：仅在 `/api/chat` 中调用，API Key 由用户通过环境变量配置（`ANTHROPIC_API_KEY` / `OPENAI_API_KEY`），不会硬编码。

---

## 4. 数据模型（核心表）

```sql
-- 用户
users (
  id            UUID PRIMARY KEY,
  email         TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  display_name  TEXT,
  height_cm     NUMERIC,       -- 用于卡路里计算
  weight_kg     NUMERIC,       -- 用于卡路里计算
  birth_date    DATE,
  created_at    TIMESTAMPTZ DEFAULT NOW()
)

-- 刷新 token（支持多端登录，每端一个）
refresh_tokens (
  id          UUID PRIMARY KEY,
  user_id     UUID REFERENCES users(id),
  device_id   TEXT NOT NULL,   -- 端标识
  token_hash  TEXT NOT NULL,
  expires_at  TIMESTAMPTZ,
  revoked_at  TIMESTAMPTZ
)

-- 运动类型元数据（运动参考表）
exercise_types (
  id                TEXT PRIMARY KEY,  -- 'running', 'walking', 'cycling', 'swimming' ...
  display_name_zh   TEXT,
  display_name_en   TEXT,
  met              NUMERIC NOT NULL,   -- MET 值，用于卡路里计算
  notes             TEXT               -- 注意事项（Markdown）
)

-- 运动记录
exercise_records (
  id           UUID PRIMARY KEY,
  user_id      UUID REFERENCES users(id),
  type_id      TEXT REFERENCES exercise_types(id),
  started_at   TIMESTAMPTZ NOT NULL,
  duration_sec INTEGER NOT NULL,
  distance_km  NUMERIC,
  calories     NUMERIC NOT NULL,       -- 服务端按公式计算后存库
  client_id    TEXT,                   -- 移动端去重 ID
  created_at   TIMESTAMPTZ DEFAULT NOW()
)

-- 每日步数（移动端周期性上报）
daily_steps (
  user_id     UUID REFERENCES users(id),
  date        DATE NOT NULL,
  steps       INTEGER NOT NULL,
  source      TEXT,                    -- 'ios_pedometer' / 'android_sensor'
  updated_at  TIMESTAMPTZ,
  PRIMARY KEY (user_id, date)
)

-- 食物营养成分（大表，导入开源数据集）
food_nutrients (
  id              BIGSERIAL PRIMARY KEY,
  source          TEXT,                -- 'usda' / 'cn_food'
  external_id     TEXT,
  name            TEXT NOT NULL,
  name_zh         TEXT,
  category        TEXT,
  serving_size_g  NUMERIC,
  kcal_per_100g   NUMERIC,
  protein_g       NUMERIC,
  fat_g           NUMERIC,
  carbs_g         NUMERIC,
  fiber_g         NUMERIC,
  sodium_mg       NUMERIC,
  -- 可扩展：维生素、矿物质等 JSONB
  extra           JSONB
)

-- 饮食记录
diet_records (
  id           UUID PRIMARY KEY,
  user_id      UUID REFERENCES users(id),
  food_id      BIGINT REFERENCES food_nutrients(id),
  meal_type    TEXT,             -- 'breakfast' / 'lunch' / 'dinner' / 'snack'
  consumed_at  TIMESTAMPTZ,
  servings     NUMERIC NOT NULL  -- 份数
)

-- 情绪记录
mood_records (
  id          UUID PRIMARY KEY,
  user_id     UUID REFERENCES users(id),
  mood        TEXT NOT NULL,     -- 'happy' / 'anxious' / 'sad' / 'calm' / 'angry' ...
  score       SMALLINT,          -- 1-10 自评
  note        TEXT,
  recorded_at TIMESTAMPTZ
)

-- AI 对话日志
chat_logs (
  id          UUID PRIMARY KEY,
  user_id     UUID REFERENCES users(id),
  role        TEXT NOT NULL,     -- 'user' / 'assistant' / 'system'
  content     TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW()
)
```

### 关键设计决策

1. **`users.id` 使用 UUID**：跨端同步天然无冲突，客户端可以预生成 ID 离线写入。
2. **`refresh_tokens` 按 `device_id` 分行**：满足"一个账号多端"诉求，每端独立撤销。
3. **`exercise_records.client_id`**：移动端离线写库后同步用，服务端按 `(user_id, client_id)` 唯一性去重。
4. **`daily_steps` 主键 `(user_id, date)`**：同一天多次上报直接累加 / 取最大值（策略在 service 层）。
5. **`food_nutrients.extra JSONB`**：保留灵活扩展，无需 DDL 迁移。

---

## 5. 核心公式

### 5.1 卡路里消耗（MET 公式）

```
calories = MET × weight(kg) × duration(hour)
```

- `MET` 来自 `exercise_types` 表（跑步≈9.8、快走≈4.3、骑车≈7.5、游泳≈7.0 …）
- `weight` 来自 `users.weight_kg`（用户可设置，未设置时用默认 65kg 并标记）
- `duration` 来自前端传入的 `duration_sec`

> **后端权威**：客户端可以传估算值，但**最终 calories 必须由后端重算并写库**，避免客户端篡改。

### 5.2 步数 → 距离 + 卡路里（估算）

```
distance_km = steps × stride_length(m) / 1000
stride_length(m) ≈ height_cm × 0.414 / 100
calories ≈ steps × 0.04  （粗略，依赖体重）
```

仅做趋势展示，**不替代运动记录**。

---

## 6. REST API 契约（核心端点）

所有 `/api/*` 需要 `Authorization: Bearer <jwt>`。

| Method | Path | 用途 |
|--------|------|------|
| POST | `/api/auth/register` | 注册 |
| POST | `/api/auth/login` | 登录，返回 access + refresh |
| POST | `/api/auth/refresh` | 刷新 token |
| POST | `/api/auth/logout` | 注销当前设备 |
| GET | `/api/users/me` | 当前用户资料 |
| PATCH | `/api/users/me` | 更新身高体重等 |
| GET | `/api/exercise-types` | 运动类型列表（含 MET + 注意事项） |
| POST | `/api/exercises` | 创建运动记录 |
| GET | `/api/exercises?from=&to=` | 查询运动记录 |
| POST | `/api/steps` | 上报每日步数（移动端用） |
| GET | `/api/steps/today` | 今日步数 |
| GET | `/api/diet/foods?q=` | 食物搜索（分页 + 全文检索） |
| POST | `/api/diet/records` | 记录一餐 |
| GET | `/api/diet/summary?date=` | 某日营养汇总 |
| POST | `/api/mood` | 记录情绪 |
| GET | `/api/mood?from=&to=` | 情绪趋势 |
| POST | `/api/chat/messages` | 发送消息给 AI（流式返回） |
| GET | `/api/chat/history` | 对话历史 |

---

## 7. 跨端数据一致性策略

1. **认证**：每端登录 → 拿到独立的 `refresh_token`（带 `device_id`）。同一账号可同时在多个端登录。
2. **数据归属**：所有业务表外键到 `users.id`，无 `device_id` 过滤 —— 任意端查询都返回完整数据。
3. **写冲突**：客户端生成 UUID，服务端按 `(user_id, client_id)` 去重；离线写入同步时不会重复。
4. **时间同步**：所有 `TIMESTAMPTZ` 都用 UTC 存储，前端按本地时区展示。

---

## 8. 安全与合规

- 密码：bcrypt（cost 12）
- JWT：Access 15min + Refresh 7d，refresh 在数据库存哈希
- 速率限制：登录、AI 对话 端点用 `express-rate-limit`
- AI 对话：**医疗免责声明**必须出现在系统 prompt + 客户端 UI 首屏
- HTTPS：生产环境强制（Nginx / Cloudflare）
- 用户数据导出/删除：GDPR-style 接口预留（v0.2）

---

## 9. 部署形态（v0.1 目标）

```
docker-compose.yml
├── postgres        # Postgres 15
├── api             # Node.js 后端
└── (可选) nginx    # 反向代理
```

移动端 / Web 端另行打包发布。

---

## 10. 开发阶段拆分（Roadmap）

| 阶段 | 内容 | 依赖 |
|------|------|------|
| 0 | 架构设计 + 后端骨架 + Docker | — |
| 1 | 用户系统 + JWT + 跨端 | 0 |
| 2 | 运动模块（运动类型种子数据 + 卡路里公式 + 步数 API） | 1 |
| 3 | 饮食模块（数据导入 + 搜索 + 记录） | 1 |
| 4 | 心理健康模块（情绪 + AI 对话） | 1 |
| 5 | 测试 + 文档 + 部署 | 2,3,4 |
| 6+ | Web 端、移动端 | 5 |

---

## 11. 待你确认的问题

1. **移动端技术栈**：React Native 还是 Flutter？（两者都能复用本后端 API）
2. **AI 对话默认模型**：用 Claude（Anthropic API）还是 OpenAI？或者让用户自己选？
3. **食物数据集**：优先导入 USDA（英文为主，覆盖广）还是中国食物成分表（中文优先，本土食物全）？
4. **部署平台**：Vercel / Railway / 自建 VPS？影响 Dockerfile 设计。

确认后我会按 Roadmap 阶段 0 → 1 → ... 推进，每个阶段产出可运行的代码 + 测试。
