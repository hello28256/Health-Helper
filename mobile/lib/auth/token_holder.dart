// TokenHolder —— 集中管理 access/refresh token 的读写
//
// 关键设计：
// - **持久化走 SecureStorage 抽象**（生产 = PlatformSecureStorage，测试 = InMemory）
// - **写入总是两个 token 一起**（access + refresh），避免半成品状态
// - **clear 不抛错**（清空幂等，让 logout / auth-failed 流程可放心重试）
//
// 调用方：C3 dio interceptor（读 access、写更新后的两个） + D1 auth provider（登出 clear）

import 'package:health_helper/storage/secure_storage.dart';

class TokenHolder {
  TokenHolder({SecureStorage? storage}) : _storage = storage ?? PlatformSecureStorage();

  static const _accessKey = 'auth.accessToken';
  static const _refreshKey = 'auth.refreshToken';

  final SecureStorage _storage;

  /// 同时写入 access + refresh（登录、注册、rotation 后都走这里）
  Future<void> save({required String accessToken, required String refreshToken}) async {
    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw ArgumentError('accessToken 和 refreshToken 都不能为空');
    }
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  /// refresh 后单独更新两个 token（同 save 语义，但语义化命名便于阅读）
  Future<void> updateTokens({required String accessToken, required String refreshToken}) =>
      save(accessToken: accessToken, refreshToken: refreshToken);

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  /// 是否有任意 token（access 或 refresh 任一非空）
  /// 用于"是否曾登录过"的判断 —— bootstrap 时优先尝试 /me 而不是直接清场
  Future<bool> hasAny() async {
    final a = await getAccessToken();
    final r = await getRefreshToken();
    return (a != null && a.isNotEmpty) || (r != null && r.isNotEmpty);
  }

  /// 清空（logout / refresh 失败时调用）。幂等，不抛错。
  Future<void> clear() async {
    try {
      await _storage.delete(key: _accessKey);
      await _storage.delete(key: _refreshKey);
    } catch (_) {
      // 静默：清空失败不影响主流程（下次启动还会走 bootstrap）
    }
  }
}
