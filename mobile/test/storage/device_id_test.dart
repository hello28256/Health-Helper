// DeviceIdStorage 单元测试
// TDD：测试生成 + 复用 + 清空

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_helper/storage/device_id.dart';

// ===== mock shared_preferences =====
//
// SharedPreferences.setMockInitialValues() 让 in-memory 替换走通

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceIdStorage', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('首次调用生成新 uuid（长度 > 0 + 标准 uuid 格式）', () async {
      final id = await DeviceIdStorage.getOrCreate();
      expect(id, isNotEmpty);
      // uuid v4 格式：8-4-4-4-12 十六进制 + 中划线
      expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')));
    });

    test('第二次调用复用同一 id（不重新生成）', () async {
      final first = await DeviceIdStorage.getOrCreate();
      final second = await DeviceIdStorage.getOrCreate();
      expect(first, second);
    });

    test('清空后下次再生成新 id', () async {
      final first = await DeviceIdStorage.getOrCreate();
      await DeviceIdStorage.clear();
      final second = await DeviceIdStorage.getOrCreate();
      expect(first, isNot(second));
    });

    test('显式写入覆盖现有 id', () async {
      await DeviceIdStorage.getOrCreate();
      await DeviceIdStorage.set('my-custom-device');
      expect(await DeviceIdStorage.getOrCreate(), 'my-custom-device');
    });
  });
}
