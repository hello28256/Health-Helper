// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for AuthApi
void main() {
  final instance = HealthHelperApi().getAuthApi();

  group(AuthApi, () {
    // 登录
    //
    // 同端重复登录会撤销旧 refresh token 并签发新的（rotation）
    //
    //Future<AuthResult> apiAuthLoginPost(ApiAuthLoginPostRequest apiAuthLoginPostRequest) async
    test('test apiAuthLoginPost', () async {
      // TODO
    });

    // 登出（撤销当前端 refresh token）
    //
    //Future apiAuthLogoutPost(ApiAuthRefreshPostRequest apiAuthRefreshPostRequest) async
    test('test apiAuthLogoutPost', () async {
      // TODO
    });

    // 刷新 access token
    //
    // 用 refresh token 换取新 access + refresh（rotation：旧 refresh 立即撤销）
    //
    //Future<AuthResult> apiAuthRefreshPost(ApiAuthRefreshPostRequest apiAuthRefreshPostRequest) async
    test('test apiAuthRefreshPost', () async {
      // TODO
    });

    // 注册新账号
    //
    // 首次注册，返回 access + refresh token 并在服务端存 refresh token 哈希
    //
    //Future<AuthResult> apiAuthRegisterPost(ApiAuthRegisterPostRequest apiAuthRegisterPostRequest) async
    test('test apiAuthRegisterPost', () async {
      // TODO
    });

  });
}
