# Android 冒烟清单（v0.1）

> **目标**：在 Android 真机 / 模拟器上验证 9 个核心流程可走通
> **预估时间**：1 设备 × 30 分钟
> **前置条件**：
> 1. 后端跑在 `http://localhost:3000`（开发机）
> 2. 手机与开发机同 Wi-Fi（真机，使用 `http://<dev_ip>:3000`）；或模拟器用 `10.0.2.2:3000`
> 3. Firebase 项目 `health-helper-prod` 已创建，`google-services.json` 已放 `android/app/`
> 4. 设备 Android 版本 ≥ 9（Health Connect 要求 SDK 26+）
> 5. Health Connect 已从 Play Store 安装

---

## 0. 环境准备（5 分钟）

- [ ] `flutter doctor` 全绿
- [ ] `cd mobile && flutter pub get`
- [ ] 启动 Android Emulator（API 30+）：`emulator -avd Pixel_7_API_34`
- [ ] `flutter run -d emulator-5554`
- [ ] 真机：`flutter run -d <device_id>`

---

## 1. 注册 / 登录（5 分钟）

- [ ] 打开 App → splash → 自动跳 `/login`
- [ ] 点 "去注册" → 填邮箱 + 密码 → 提交
- [ ] 期望：跳到 `/dashboard`
- [ ] 杀进程 → 重启 → 仍保持登录态

---

## 2. Dashboard（3 分钟）

- [ ] 顶部"今日步数"卡片显示数值
- [ ] "AI 心理对话"卡片可点击 → 跳 `/chat`
- [ ] 底部 BottomNavigationBar 4 个 tab 正常切换

---

## 3. 记录（5 分钟）

- [ ] 点"记录"tab → 切子 tab（运动 / 饮食 / 情绪）
- [ ] **运动** → 填名称 + 时长 + 卡路里 → 提交
- [ ] **饮食** → 填名称 + 卡路里 → 提交
- [ ] **情绪** → 选 emoji (1-5) → 提交
- [ ] 后端 `prisma studio` 看到对应记录

---

## 4. 趋势（3 分钟）

- [ ] 点"趋势"tab → 步数 / 情绪切换
- [ ] 折线图渲染，无崩溃
- [ ] 空数据显示提示

---

## 5. AI 对话（3 分钟）

- [ ] 点首页"AI 心理对话" → 跳 `/chat`
- [ ] 输入"你好" → 看到用户 + AI 气泡
- [ ] 流式响应逐步出现

---

## 6. 健康数据（5 分钟）

- [ ] 点"我的" → "健康数据" → `/health`
- [ ] **首次进入**：弹出 Health Connect 权限请求（READ_STEPS / READ_HEART_RATE / READ_SLEEP / READ_WEIGHT / READ_BLOOD_PRESSURE / READ_BLOOD_GLUCOSE / READ_OXYGEN_SATURATION / READ_BODY_TEMPERATURE）
- [ ] 同意后：8 个 tab 可切换
- [ ] 步数 tab 显示 Health Connect 最近 7 天数据
- [ ] 关闭 Health Connect 权限（设置 → 健康连接 → 数据与权限）→ 重启 App → banner 提示

---

## 7. 推送（5 分钟）

- [ ] App 在前台 → 后端触发 mood 连续负向 → 顶部弹出本地通知
- [ ] App 在后台 → 通知仍展示（走 FCM）
- [ ] App 已杀进程 → 冷启动后仍能收到推送

---

## 8. 401 自动刷新（2 分钟）

- [ ] 登录后等 15 分钟（access token 过期）
- [ ] 在 dashboard 操作 → 自动 refresh → 重发请求，无感知

---

## 9. 登出（1 分钟）

- [ ] "我的" → "退出登录" → 确认
- [ ] 期望：跳 `/login`，token 清空

---

## 已知限制

- Health Connect 仅 **Android 9+** 可用（`minSdk=26` 已配置）
- Android < 9 设备：UI 检测后降级为只读历史记录（**V0.1 暂未实现**）
- 多用户多设备同步已 OK，但推送只发给当前 deviceId

---

## 通过标准

- ✅ 9 个流程全部勾完，无 crash
- ✅ 后端 `prisma studio` 看到所有数据
- ✅ 推送在前后台都能正常展示
- ✅ Health Connect 权限引导 UI 正常展示

---

## 故障排查

| 现象 | 排查 |
|------|------|
| Health Connect 权限弹窗没出 | 检查 `AndroidManifest.xml` 是否声明了 READ_* 权限；`minSdk=26` 是否生效 |
| 推送收不到 | 检查 `google-services.json` 包名是否与 `applicationId` 一致；后端 `FCM_SERVICE_ACCOUNT_PATH` 是否配置 |
| 网络请求失败 | 真机需把 `baseUrl` 改为 `http://<dev_ip>:3000`；模拟器用 `10.0.2.2:3000` |
| 注册后跳不到 dashboard | 后端是否在跑？`curl http://localhost:3000/api/auth/health` 应返回 200 |