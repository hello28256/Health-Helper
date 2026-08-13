// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for HealthApi
void main() {
  final instance = HealthHelperApi().getHealthApi();

  group(HealthApi, () {
    // 按 metric + 时间窗查询历史
    //
    //Future<ApiHealthRecordsGet200Response> apiHealthRecordsGet(HealthMetric metric, DateTime from, DateTime to) async
    test('test apiHealthRecordsGet', () async {
      // TODO
    });

    // 查询某 metric 的最新一条
    //
    //Future<ApiHealthRecordsLatestGet200Response> apiHealthRecordsLatestGet(HealthMetric metric) async
    test('test apiHealthRecordsLatestGet', () async {
      // TODO
    });

    // 批量上报健康数据
    //
    // mobile 端从 HealthKit / Health Connect 同步时批量上报。上限 500 条/请求；steps 走专用 /api/exercises/steps 端点。
    //
    //Future<ApiHealthRecordsGet200Response> apiHealthRecordsPost(ApiHealthRecordsPostRequest apiHealthRecordsPostRequest) async
    test('test apiHealthRecordsPost', () async {
      // TODO
    });

  });
}
