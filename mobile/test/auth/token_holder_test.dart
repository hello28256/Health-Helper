// TokenHolder 单元测试
// TDD：测试写入 → 读出 → 清空的完整循环

import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/storage/secure_storage.dart';

// ===== mock secure storage =====
//
// flutter_secure_storage 不方便在单测里直接 mock（platform channel），
// 这里走一个 InMemory 实现替换它，绕开 platform dependency。
class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read({required String key}) async => _store[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}

void main() {
  late InMemorySecureStorage storage;
  late TokenHolder holder;

  setUp(() {
    storage = InMemorySecureStorage();
    holder = TokenHolder(storage: storage);
  });

  group('save / read', () {
    test('保存 accessToken 后能读出', () async {
      await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
      expect(await holder.getAccessToken(), 'access-1');
      expect(await holder.getRefreshToken(), 'refresh-1');
    });

    test('从未存过时返回 null', () async {
      expect(await holder.getAccessToken(), isNull);
      expect(await holder.getRefreshToken(), isNull);
    });

    test('覆盖写入：后写覆盖先写', () async {
      await holder.save(accessToken: 'a-old', refreshToken: 'r-old');
      await holder.save(accessToken: 'a-new', refreshToken: 'r-new');
      expect(await holder.getAccessToken(), 'a-new');
      expect(await holder.getRefreshToken(), 'r-new');
    });
  });

  group('hasAny', () {
    test('空状态返回 false', () async {
      expect(await holder.hasAny(), isFalse);
    });

    test('只存 accessToken 视为 true', () async {
      // 直接写底层 storage，模拟"只有 access 没有 refresh"的不一致状态
      await storage.write(key: 'auth.accessToken', value: 'a');
      expect(await holder.hasAny(), isTrue);
    });
  });

  group('clear', () {
    test('清空后读出 null', () async {
      await holder.save(accessToken: 'a', refreshToken: 'r');
      await holder.clear();
      expect(await holder.getAccessToken(), isNull);
      expect(await holder.getRefreshToken(), isNull);
    });

    test('多次清空不抛错', () async {
      await holder.clear();
      await holder.clear();
      expect(await holder.getAccessToken(), isNull);
    });
  });

  group('rotation', () {
    test('updateTokens 单独更新 access + refresh', () async {
      await holder.save(accessToken: 'a-old', refreshToken: 'r-old');
      await holder.updateTokens(accessToken: 'a-new', refreshToken: 'r-new');
      expect(await holder.getAccessToken(), 'a-new');
      expect(await holder.getRefreshToken(), 'r-new');
    });
  });
}
