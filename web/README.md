# Health Helper Web 前端

> 跨端健康助手（身心）的 Web 客户端 · React 18 + TypeScript + Vite + Tailwind

## 功能

- ✅ 邮箱注册/登录（access + refresh token，401 自动续期）
- ✅ 仪表盘：今日步数环 + 饮食汇总 + 运动/情绪列表
- ✅ 4 tab 记录：运动 / 饮食 / 步数 / 情绪
- ✅ 趋势：7/30 天切换 · 情绪折线图 · 步数柱状图
- ✅ AI 健康助手抽屉（侧拉，Enter 发 / Shift+Enter 换行）
- ✅ 移动端 + 桌面响应式（同一份代码）

## 技术栈

| 层 | 选型 |
|----|------|
| 构建 | Vite 5 |
| UI | React 18 + TypeScript 5 (strict) |
| 样式 | Tailwind CSS 3 |
| 状态 | Zustand（auth/UI） + React Query（业务数据） |
| 路由 | React Router 6 |
| 图表 | Recharts |
| HTTP | Axios + 自研 401 refresh 队列 |
| 类型 | openapi-typescript 从后端 `/api/docs/openapi.json` 生成 |
| 测试 | Vitest + React Testing Library |

## 目录结构

```
web/
├── src/
│   ├── api/              # Axios client + 各模块 typed wrapper
│   ├── stores/           # Zustand (auth / UI)
│   ├── hooks/            # React Query hooks
│   ├── lib/              # 工具（deviceId, format, icons）
│   ├── components/
│   │   ├── ui/           # Button / Input / Card / Tabs / Spinner / Toast
│   │   ├── layout/       # AppShell (移动+桌面)
│   │   ├── steps/        # 步数环 + 柱状图
│   │   ├── exercise/     # 列表 + 表单
│   │   ├── diet/         # 汇总 + 搜索 + 表单
│   │   ├── mood/         # 列表 + 折线图 + 表单
│   │   └── chat/         # 抽屉
│   ├── pages/            # 4 个 MVP 页面
│   ├── types/api.d.ts    # openapi-typescript 生成（不入库）
│   ├── App.tsx
│   ├── main.tsx
│   └── router.tsx
├── tests/                # Vitest 单测
└── scripts/codegen.sh    # 拉 OpenAPI → 生成类型
```

## 快速开始

### 1. 启动后端（必须）

```bash
cd ../
docker compose up -d postgres
npm install
npx prisma migrate deploy
npx prisma generate
# seed 数据
npx tsx prisma/seed.ts           # 运动类型
npx tsx prisma/seed-foods.ts     # 食物
npm run dev                       # :3000
```

### 2. 启动前端

```bash
cd web
npm install
cp .env.example .env              # 默认 VITE_API_BASE_URL=http://localhost:3000
npm run dev                        # :5173
```

打开 http://localhost:5173 注册账号 → 用。

### 3. 修改后端 schema 后同步类型

```bash
npm run codegen    # 拉 /api/docs/openapi.json → 生成 src/types/api.d.ts
```

## 命令

| 命令 | 作用 |
|------|------|
| `npm run dev` | 启动 Vite dev server (5173) |
| `npm run build` | 类型检查 + 生产构建到 `dist/` |
| `npm run preview` | 本地预览生产构建 |
| `npm run typecheck` | `tsc --noEmit` |
| `npm run lint` | ESLint (max-warnings 0) |
| `npm run format` | Prettier |
| `npm test` | Vitest 跑所有单测 |
| `npm run test:watch` | Vitest 监听模式 |
| `npm run codegen` | 从后端 OpenAPI 生成 TS 类型 |

## 测试

- `tests/client.test.ts` —— Axios 401 refresh 队列、request 拦截器
- `tests/authStore.test.ts` —— login / register / logout / bootstrap 状态机

```bash
npm test
```

## 关键设计

### 401 refresh 队列（防风暴）

多个请求同时 401 时，只发一个 `/api/auth/refresh`，其他 await 同一 Promise：

```ts
// src/api/client.ts
let refreshInFlight: Promise<void> | null = null;

apiClient.interceptors.response.use(null, async (error) => {
  if (error.response?.status !== 401) return Promise.reject(error);
  if (!refreshInFlight) {
    refreshInFlight = doRefresh().finally(() => { refreshInFlight = null; });
  }
  await refreshInFlight;
  return apiClient.retry(error.config);
});
```

### deviceId 持久化

浏览器复用同一个 `crypto.randomUUID()`，存 localStorage。后端用 `(userId, deviceId)` 唯一识别 refresh token，让"同账号多端"独立管理会话。

### 状态机

| 文件 | 内容 |
|------|------|
| `src/stores/authStore.ts` | tokens + user + deviceId，persist 到 localStorage（**不存 user**，每次启动拉 /me） |
| `src/stores/uiStore.ts` | 抽屉开关 + toasts |

### 业务数据全走 React Query

每个 hook 一个 queryKey 命名空间，mutation 后 `invalidateQueries` 自动刷新。

## 不在 MVP 范围

- 暗色模式切换
- PWA / Service Worker
- 推送通知
- 多语言 i18n
- 数据导出 CSV
- 食物图片

需要可加。

## 与后端 CORS

`.env` 里后端 `CORS_ORIGINS` 默认包含 `http://localhost:5173`。生产部署把正式域名加进去。

## 部署

`npm run build` 产物在 `dist/`，是个纯静态站。可放到：

- **Nginx**：把 `dist/` 配成 root，所有路径 fallback 到 `/index.html`（React Router）
- **Vercel / Netlify**：自动识别 Vite，`VITE_API_BASE_URL` 走环境变量
- **CDN**：同上

`/api/*` 请求要么在生产同源（用 Nginx 反代），要么后端 CORS 放行正式域名。
