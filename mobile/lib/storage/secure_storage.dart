// SecureStorage —— 加密存储抽象
//
// 真实实现：FlutterSecureStorage（iOS keychain / Android EncryptedSharedPreferences）
// 测试实现：见 test/auth/token_holder_test.dart 里的 InMemorySecureStorage
//
// 设计要点：
// - 抽象成接口，避免单测里走 platform channel
// - 调用方永远用 SecureStorage 接口，不直接 new FlutterSecureStorage

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<void> clear();
}

/// 生产实现：委托给 FlutterSecureStorage
class PlatformSecureStorage implements SecureStorage {
  PlatformSecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
