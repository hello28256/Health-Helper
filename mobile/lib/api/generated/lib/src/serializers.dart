// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:health_helper_api/src/date_serializer.dart';
import 'package:health_helper_api/src/model/date.dart';

import 'package:health_helper_api/src/model/api_auth_login_post_request.dart';
import 'package:health_helper_api/src/model/api_auth_refresh_post_request.dart';
import 'package:health_helper_api/src/model/api_auth_register_post_request.dart';
import 'package:health_helper_api/src/model/api_chat_history_get200_response.dart';
import 'package:health_helper_api/src/model/api_chat_messages_post_request.dart';
import 'package:health_helper_api/src/model/api_devices_post_request.dart';
import 'package:health_helper_api/src/model/api_diet_foods_get200_response.dart';
import 'package:health_helper_api/src/model/api_diet_records_get200_response.dart';
import 'package:health_helper_api/src/model/api_diet_records_post_request.dart';
import 'package:health_helper_api/src/model/api_exercises_get200_response.dart';
import 'package:health_helper_api/src/model/api_exercises_post_request.dart';
import 'package:health_helper_api/src/model/api_exercises_steps_post_request.dart';
import 'package:health_helper_api/src/model/api_exercises_types_get200_response.dart';
import 'package:health_helper_api/src/model/api_health_records_get200_response.dart';
import 'package:health_helper_api/src/model/api_health_records_latest_get200_response.dart';
import 'package:health_helper_api/src/model/api_health_records_post_request.dart';
import 'package:health_helper_api/src/model/api_health_records_post_request_records_inner.dart';
import 'package:health_helper_api/src/model/api_mood_get200_response.dart';
import 'package:health_helper_api/src/model/api_mood_post_request.dart';
import 'package:health_helper_api/src/model/api_mood_trend_get200_response.dart';
import 'package:health_helper_api/src/model/api_users_me_patch_request.dart';
import 'package:health_helper_api/src/model/auth_result.dart';
import 'package:health_helper_api/src/model/chat_message.dart';
import 'package:health_helper_api/src/model/chat_send_result.dart';
import 'package:health_helper_api/src/model/daily_nutrition_summary.dart';
import 'package:health_helper_api/src/model/daily_nutrition_summary_by_meal_value.dart';
import 'package:health_helper_api/src/model/daily_step.dart';
import 'package:health_helper_api/src/model/device_platform.dart';
import 'package:health_helper_api/src/model/device_token.dart';
import 'package:health_helper_api/src/model/diet_record.dart';
import 'package:health_helper_api/src/model/diet_record_consumed.dart';
import 'package:health_helper_api/src/model/error.dart';
import 'package:health_helper_api/src/model/error_error.dart';
import 'package:health_helper_api/src/model/exercise_record.dart';
import 'package:health_helper_api/src/model/exercise_type.dart';
import 'package:health_helper_api/src/model/food.dart';
import 'package:health_helper_api/src/model/health_metric.dart';
import 'package:health_helper_api/src/model/health_record.dart';
import 'package:health_helper_api/src/model/mood_record.dart';
import 'package:health_helper_api/src/model/mood_trend_point.dart';
import 'package:health_helper_api/src/model/public_user.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiAuthLoginPostRequest,
  ApiAuthRefreshPostRequest,
  ApiAuthRegisterPostRequest,
  ApiChatHistoryGet200Response,
  ApiChatMessagesPostRequest,
  ApiDevicesPostRequest,
  ApiDietFoodsGet200Response,
  ApiDietRecordsGet200Response,
  ApiDietRecordsPostRequest,
  ApiExercisesGet200Response,
  ApiExercisesPostRequest,
  ApiExercisesStepsPostRequest,
  ApiExercisesTypesGet200Response,
  ApiHealthRecordsGet200Response,
  ApiHealthRecordsLatestGet200Response,
  ApiHealthRecordsPostRequest,
  ApiHealthRecordsPostRequestRecordsInner,
  ApiMoodGet200Response,
  ApiMoodPostRequest,
  ApiMoodTrendGet200Response,
  ApiUsersMePatchRequest,
  AuthResult,
  ChatMessage,
  ChatSendResult,
  DailyNutritionSummary,
  DailyNutritionSummaryByMealValue,
  DailyStep,
  DevicePlatform,
  DeviceToken,
  DietRecord,
  DietRecordConsumed,
  Error,
  ErrorError,
  ExerciseRecord,
  ExerciseType,
  Food,
  HealthMetric,
  HealthRecord,
  MoodRecord,
  MoodTrendPoint,
  PublicUser,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
