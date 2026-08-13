// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for UsersApi
void main() {
  final instance = HealthHelperApi().getUsersApi();

  group(UsersApi, () {
    // 获取当前用户资料
    //
    //Future<PublicUser> apiUsersMeGet() async
    test('test apiUsersMeGet', () async {
      // TODO
    });

    // 更新用户资料
    //
    // 部分更新 —— 体重 weightKg 用于卡路里计算
    //
    //Future<PublicUser> apiUsersMePatch(ApiUsersMePatchRequest apiUsersMePatchRequest) async
    test('test apiUsersMePatch', () async {
      // TODO
    });

  });
}
