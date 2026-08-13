// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for DevicesApi
void main() {
  final instance = HealthHelperApi().getDevicesApi();

  group(DevicesApi, () {
    // 撤销某 device 的所有 token
    //
    // 幂等：找不到时也返回 204，mobile 端 token rotation 时反复调用不报错
    //
    //Future apiDevicesDeviceIdDelete(String deviceId) async
    test('test apiDevicesDeviceIdDelete', () async {
      // TODO
    });

    // 注册/更新推送 token
    //
    // 幂等 upsert：key = (userId, deviceId, platform)。APNs / FCM 换 token 时再调一次即可覆盖。fcmToken 和 apnsToken 至少要传一个。
    //
    //Future<DeviceToken> apiDevicesPost(ApiDevicesPostRequest apiDevicesPostRequest) async
    test('test apiDevicesPost', () async {
      // TODO
    });

  });
}
