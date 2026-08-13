// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for MoodApi
void main() {
  final instance = HealthHelperApi().getMoodApi();

  group(MoodApi, () {
    // 查询情绪记录
    //
    //Future<ApiMoodGet200Response> apiMoodGet({ DateTime from, DateTime to }) async
    test('test apiMoodGet', () async {
      // TODO
    });

    // 记录一次情绪
    //
    //Future<MoodRecord> apiMoodPost(ApiMoodPostRequest apiMoodPostRequest) async
    test('test apiMoodPost', () async {
      // TODO
    });

    // 查询情绪趋势（按日聚合）
    //
    //Future<ApiMoodTrendGet200Response> apiMoodTrendGet(DateTime from, DateTime to) async
    test('test apiMoodTrendGet', () async {
      // TODO
    });

  });
}
