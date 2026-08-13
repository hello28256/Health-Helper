// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for DietApi
void main() {
  final instance = HealthHelperApi().getDietApi();

  group(DietApi, () {
    // 搜索食物营养库
    //
    //Future<ApiDietFoodsGet200Response> apiDietFoodsGet({ String q, String category, int limit, int offset }) async
    test('test apiDietFoodsGet', () async {
      // TODO
    });

    // 查询某时间段的饮食记录
    //
    //Future<ApiDietRecordsGet200Response> apiDietRecordsGet(DateTime from, DateTime to) async
    test('test apiDietRecordsGet', () async {
      // TODO
    });

    // 记录一餐
    //
    // 服务端计算 consumed = servings × servingSizeG/100 × per100g
    //
    //Future<DietRecord> apiDietRecordsPost(ApiDietRecordsPostRequest apiDietRecordsPostRequest) async
    test('test apiDietRecordsPost', () async {
      // TODO
    });

    // 查询某日营养汇总
    //
    //Future<DailyNutritionSummary> apiDietSummaryGet({ DateTime date }) async
    test('test apiDietSummaryGet', () async {
      // TODO
    });

  });
}
