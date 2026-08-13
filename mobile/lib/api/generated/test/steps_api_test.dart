// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for StepsApi
void main() {
  final instance = HealthHelperApi().getStepsApi();

  group(StepsApi, () {
    // 上报每日步数
    //
    // 同日多次上报采用 **max-value 策略**（避免移动端 OS 回退）
    //
    //Future<DailyStep> apiExercisesStepsPost(ApiExercisesStepsPostRequest apiExercisesStepsPostRequest) async
    test('test apiExercisesStepsPost', () async {
      // TODO
    });

    // 查询今日步数
    //
    //Future<DailyStep> apiExercisesStepsTodayGet() async
    test('test apiExercisesStepsTodayGet', () async {
      // TODO
    });

  });
}
