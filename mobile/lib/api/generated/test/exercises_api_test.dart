// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for ExercisesApi
void main() {
  final instance = HealthHelperApi().getExercisesApi();

  group(ExercisesApi, () {
    // 查询运动记录
    //
    //Future<ApiExercisesGet200Response> apiExercisesGet({ DateTime from, DateTime to }) async
    test('test apiExercisesGet', () async {
      // TODO
    });

    // 创建运动记录
    //
    // calories 由服务端按 MET 公式权威计算（**不接受客户端传入 calories**）
    //
    //Future<ExerciseRecord> apiExercisesPost(ApiExercisesPostRequest apiExercisesPostRequest) async
    test('test apiExercisesPost', () async {
      // TODO
    });

    // 列出所有运动类型（含 MET + 注意事项）
    //
    //Future<ApiExercisesTypesGet200Response> apiExercisesTypesGet() async
    test('test apiExercisesTypesGet', () async {
      // TODO
    });

  });
}
