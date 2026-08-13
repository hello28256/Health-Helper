# Health Helper · Mobile App（Flutter）

> **版本**：v0.1 · **日期**：2026-08-13
> iOS + Android 双端原生 Flutter App，对接现有 Node.js + Postgres 后端

---

## 项目位置

`/Users/yangq/Codes/Health-Helper/mobile/`

```
Health-Helper/
├── src/          # 后端
├── prisma/
├── web/          # Web 前端
├── docs/
└── mobile/       # ← 你在这里
```

---

## 技术栈

| 类别 | 选型 |
|------|------|
| Framework | Flutter 3.44+ / Dart 3.10+ |
| 状态 | flutter_riverpod 2.6 |
| 路由 | go_router 17 |
| HTTP | dio 5 + QueuedInterceptorsWrapper + Completer 单例锁 |
| 存储 | flutter_secure_storage（token）+ shared_preferences（deviceId） |
| 健康数据 | health 13（HealthKit + Health Connect 统一接口） |
| 推送 | firebase_messaging 16 + flutter_local_notifications 22 |
| 图表 | fl_chart 0.69 |
| 测试 | mocktail 1 + integration_test |

---

## 快速开始

```bash
cd /Users/yangq/Codes/Health-Helper/mobile

# 1. 拉依赖
flutter pub get

# 2. 跑 codegen（spec 变了才需要）
bash scripts/codegen.sh
dart run build_runner build --delete-conflicting-outputs
flutter pub get   # 二次拉依赖
dart run build_runner build --delete-conflicting-outputs

# 3. 启动模拟器
flutter emulators --launch "iPhone 15 Pro"   # iOS
# 或
emulator -avd Pixel_7_API_34                 # Android

# 4. 跑 App
flutter run -d "iPhone 15 Pro"
```

---

## 跑测试

```bash
# 单元测试 + widget 测试（154 个用例）
flutter test

# 单文件
flutter test test/providers/auth_provider_test.dart

# integration_test（需真后端 + 真机/模拟器）
flutter test integration_test -d "iPhone 15 Pro"

# Lint
flutter analyze
```

---

## 关键目录

```
lib/
├── main.dart                    # bootstrap（Firebase + FCM + runApp）
├── app.dart                     # HealthHelperApp（MaterialApp.router）
├── api/
│   ├── dio_client.dart          # ★ 401 refresh Completer 单例锁
│   ├── api_clients.dart         # 9 个 generated API 聚合
│   └── api_error.dart
├── api/generated/               # openapi_generator 产物（不手改）
├── auth/
│   └── token_holder.dart        # token holder 单例
├── providers/                   # 8 个 Riverpod provider
│   ├── auth_provider.dart       # AsyncNotifier<AuthState>
│   ├── exercises_provider.dart
│   ├── steps_provider.dart
│   ├── diet_provider.dart
│   ├── mood_provider.dart
│   ├── chat_provider.dart
│   ├── health_provider.dart
│   └── push_provider.dart
├── router/
│   └── app_router.dart          # go_router redirect + refreshListenable
├── pages/                       # 10 个页面
│   ├── auth/{login,register}_page.dart
│   ├── dashboard/dashboard_page.dart
│   ├── record/record_page.dart
│   ├── trend/trend_page.dart
│   ├── chat/chat_page.dart
│   ├── health/health_data_page.dart
│   └── settings/{settings,profile}_page.dart
├── widgets/common/              # AppScaffold / AsyncValueWidget / ErrorView
├── services/
│   ├── health_sync.dart         # ★ HealthKit/Health Connect → 后端上报
│   └── fcm_service.dart         # ★ FCM 推送 + 本地通知
├── storage/                     # secure_storage / device_id
├── theme/                       # Material 3 theme + design tokens
└── utils/

test/                            # 154 个单测 / widget 测试
integration_test/                # E2E 冒烟（真机 + 真后端）
docs/
├── SMOKE_IOS.md                 # iOS 冒烟清单
├── SMOKE_ANDROID.md             # Android 冒烟清单
└── ARCHITECTURE.md              # 架构说明
```

---

## 配置

### 后端 baseUrl

`lib/api/api_clients.dart` 默认 `http://localhost:3000`。
真机调试改为 `http://<dev_ip>:3000`，模拟器 Android 用 `10.0.2.2:3000`。

### Firebase

- iOS: `ios/Runner/GoogleService-Info.plist`（不入 git，本地配置）
- Android: `android/app/google-services.json`（不入 git，本地配置）

### HealthKit / Health Connect

- iOS `Info.plist`：`NSHealthShareUsageDescription`、`NSHealthUpdateUsageDescription`
- Android `AndroidManifest.xml`：8 个 `android.permission.health.READ_*`
- `android/app/build.gradle.kts`：`minSdk = 26`

### APNs（仅 iOS 后端需要）

后端 `.env` 配 `APNS_*` 6 个 key，mobile 端不用配。

---

## 核心设计

### 1. dio 401 refresh 单例锁（`lib/api/dio_client.dart`）

并发 401 只触发一次 refresh，所有请求 await 同一个 Completer：

```dart
Completer<void>? _refreshInFlight;
```

避免轮询 `bool isRefreshing`，避免 token 重复刷新。

### 2. AuthNotifier sealed class（`lib/providers/auth_provider.dart`）

```dart
sealed class AuthState { ... }
class AuthIdle extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState { final PublicUser user; }
class Unauthenticated extends AuthState { final String? error; }
```

### 3. 健康数据上报（`lib/services/health_sync.dart`）

HealthKit / Health Connect → 抽象 `HealthPlatform` 接口 → `HealthSync.syncMetric()` → 后端 `POST /api/exercises/steps` 或 `POST /api/health/records`。
**接口 vs 实现分离**让单元测试不需要真机权限。

### 4. FCM token 注册（`lib/app.dart`）

监听 `authProvider`：登录成功 → `push.register()`；登出 → `push.revoke()`。幂等：相同 token 跳过。

---

## 常见问题

| 现象 | 解决 |
|------|------|
| `flutter run` 卡在 "Waiting for another flutter command" | `pkill -9 -f flutter` 或重启终端 |
| HealthKit 权限弹窗没出 | iOS `Info.plist` 检查 `NSHealthShareUsageDescription` |
| Health Connect 没数据 | 设备 Android 版本 ≥ 9；Health Connect App 已装 |
| 推送收不到 | Firebase 项目是否启用了 Cloud Messaging；后端 FCM 私钥是否配置 |
| codegen 后报类型错误 | `flutter pub get` 再跑一次 `build_runner build` |
| `flutter analyze` 报 lint | 大多 unused_import / sort_constructors_first；改完 import 即可 |

---

## 后续 Sprint 计划

- **V0.2**：体重 / 血压历史趋势图；离线缓存（hive）；多语言 i18n
- **V0.3**：深链（`healthhelper://`）；Sentry 错误上报；CSV 数据导出
- **V1.0**：Apple Watch / Wear OS 适配；Widget Extension

---

## 参考文档

- [iOS 冒烟清单](docs/SMOKE_IOS.md)
- [Android 冒烟清单](docs/SMOKE_ANDROID.md)
- [后端架构](../docs/ARCHITECTURE.md)
- [实施计划](../.claude/plans/wise-riding-feigenbaum.md)