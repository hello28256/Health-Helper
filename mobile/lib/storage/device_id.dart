// DeviceIdStorage —— 设备唯一标识
//
// 设计要点：
// - 首次启动生成 uuid v4 存 SharedPreferences
// - 后续启动复用同一 id（用于后端 refresh token 按 device 隔离）
// - 用户手动清缓存 / 卸载重装会重新生成（正常）
// - 不存 secure_storage：deviceId 不是敏感数据，普通 prefs 即可

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdStorage {
  static const _key = 'device.id';

  /// 读取现有 id，没有就生成并保存。
  /// 全局只一份状态，多处调用返回同一值。
  static Future<String> getOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing != null && existing.isNotEmpty) return existing;

    final fresh = const Uuid().v4();
    await prefs.setString(_key, fresh);
    return fresh;
  }

  /// 显式写入（测试或调试用）
  static Future<void> set(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, id);
  }

  /// 清空（卸载 / 切换账号场景）
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
