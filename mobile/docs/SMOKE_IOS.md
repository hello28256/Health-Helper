# iOS 冒烟清单（v0.1）

> **目标**：在 iPhone 真机 / 模拟器上验证 9 个核心流程可走通
> **预估时间**：1 设备 × 30 分钟
> **前置条件**：
> 1. 后端跑在 `http://localhost:3000`（开发机）
> 2. 手机与开发机同 Wi-Fi（真机）；或使用模拟器直接访问 `localhost:3000`
> 3. Firebase 项目 `health-helper-prod` 已创建，`GoogleService-Info.plist` 已放 `ios/Runner/`
> 4. Apple Developer 后台已配 APNs Key（.p8）

---

## 0. 环境准备（5 分钟）

- [ ] `flutter doctor` 全绿
- [ ] `cd mobile && flutter pub get`
- [ ] `flutter run -d "iPhone 15 Pro"` 启动到模拟器
- [ ] 真机：`flutter run -d <device_id>`

---

## 1. 注册 / 登录（5 分钟）

- [ ] 打开 App → splash → 自动跳 `/login`
- [ ] 点 "去注册" → 填邮箱（**用真实邮箱**，避免被 kick）+ 密码 → 提交
- [ ] 期望：跳到 `/dashboard`，顶部显示"今日步数"卡片
- [ ] 杀进程 → 重启 → 仍保持登录态（验证 token 持久化）

---

## 2. Dashboard（3 分钟）

- [ ] 顶部"今日步数"卡片显示数值（mock 数据应为 0；连 HealthKit 后显示真实步数）
- [ ] "AI 心理对话"卡片可点击 → 跳 `/chat`
- [ ] 底部 BottomNavigationBar 4 个 tab（首页 / 记录 / 趋势 / 我的）正常切换

---

## 3. 记录（5 分钟）

- [ ] 点"记录"tab → 切到子 tab（运动 / 饮食 / 情绪）
- [ ] **运动**：填名称 + 时长 + 卡路里 → 提交 → 回到 dashboard 看到新卡片
- [ ] **饮食**：填名称 + 卡路里 → 提交
- [ ] **情绪**：选 emoji (1-5) → 提交
- [ ] 后端 `prisma studio`（`http://localhost:5555`）看到对应记录

---

## 4. 趋势（3 分钟）

- [ ] 点"趋势"tab → 步数 / 情绪切换
- [ ] 期望：折线图渲染（fl_chart），无崩溃
- [ ] 空数据状态显示提示文案

---

## 5. AI 对话（3 分钟）

- [ ] 点首页"AI 心理对话" → 跳 `/chat`
- [ ] 输入"你好" → 看到用户消息 + AI 回复气泡
- [ ] 发送历史消息滚动到底部
- [ ] 流式响应：AI 消息应逐步出现文字（不是整段弹出来）

---

## 6. 健康数据（5 分钟）

- [ ] 点"我的" → "健康数据" → 进入 `/health`
- [ ] **首次进入**：弹出 HealthKit 权限请求（NSHealthShareUsageDescription）
- [ ] 同意后：8 个 tab（步数 / 心率 / 睡眠 / 体重 / 血压 / 血糖 / 血氧 / 体温）可切换
- [ ] 步数 tab 应显示最近 7 天数据（来自 HealthKit）
- [ ] 关闭 HealthKit 权限（设置 → 健康 → 数据来源与访问权限）→ 重启 App → banner 提示"权限被拒绝"

---

## 7. 推送（5 分钟）

- [ ] App 在前台 → 后端触发 mood 连续负向（手动改 DB `mood.score < 4` 连续 7 天）
- [ ] 期望：设备顶部弹出本地通知（带声音 + badge）
- [ ] 点通知 → App 跳到 `/chat` 或 `/trend`（**V0.1 暂不实现跳转逻辑**）
- [ ] App 在后台 → 推送仍能展示（走 APNs）
- [ ] App 已杀进程 → 启动后仍能收到推送（走 FCM/APNs 冷启动）

---

## 8. 401 自动刷新（2 分钟）

- [ ] 登录后 → 等待 15 分钟（access token 过期）
- [ ] 在 dashboard 上滑刷新 / 切 tab → 后端应收到 401 → 自动 refresh → 重发请求
- [ ] 期望：操作无感知、不跳登录页

---

## 9. 登出（1 分钟）

- [ ] "我的" → "退出登录" → 确认对话框 → 点确认
- [ ] 期望：跳 `/login`，token 被清空（杀进程重启仍停在登录页）

---

## 已知限制

- iOS Simulator **不支持真 APNs**，前台消息通过 `flutter_local_notifications` 模拟
- Apple Watch / iPad 适配不在 V0.1 范围
- 深链（`healthhelper://chat/{id}`）V0.1 未实现

---

## 通过标准

- ✅ 9 个流程全部勾完，无 crash
- ✅ 后端 `prisma studio` 看到所有上报数据（exercise / diet / mood / step / healthRecord / deviceToken）
- ✅ 推送在前后台都能正常展示