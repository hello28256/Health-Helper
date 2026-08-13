// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(ApiAuthLoginPostRequest.serializer)
      ..add(ApiAuthRefreshPostRequest.serializer)
      ..add(ApiAuthRegisterPostRequest.serializer)
      ..add(ApiChatHistoryGet200Response.serializer)
      ..add(ApiChatMessagesPostRequest.serializer)
      ..add(ApiDevicesPostRequest.serializer)
      ..add(ApiDietFoodsGet200Response.serializer)
      ..add(ApiDietRecordsGet200Response.serializer)
      ..add(ApiDietRecordsPostRequest.serializer)
      ..add(ApiDietRecordsPostRequestMealTypeEnum.serializer)
      ..add(ApiExercisesGet200Response.serializer)
      ..add(ApiExercisesPostRequest.serializer)
      ..add(ApiExercisesStepsPostRequest.serializer)
      ..add(ApiExercisesStepsPostRequestSource_Enum.serializer)
      ..add(ApiExercisesTypesGet200Response.serializer)
      ..add(ApiHealthRecordsGet200Response.serializer)
      ..add(ApiHealthRecordsLatestGet200Response.serializer)
      ..add(ApiHealthRecordsPostRequest.serializer)
      ..add(ApiHealthRecordsPostRequestRecordsInner.serializer)
      ..add(ApiMoodGet200Response.serializer)
      ..add(ApiMoodPostRequest.serializer)
      ..add(ApiMoodPostRequestMoodEnum.serializer)
      ..add(ApiMoodTrendGet200Response.serializer)
      ..add(ApiUsersMePatchRequest.serializer)
      ..add(AuthResult.serializer)
      ..add(ChatMessage.serializer)
      ..add(ChatMessageRoleEnum.serializer)
      ..add(ChatSendResult.serializer)
      ..add(DailyNutritionSummary.serializer)
      ..add(DailyNutritionSummaryByMealValue.serializer)
      ..add(DailyStep.serializer)
      ..add(DailyStepSource_Enum.serializer)
      ..add(DevicePlatform.serializer)
      ..add(DeviceToken.serializer)
      ..add(DietRecord.serializer)
      ..add(DietRecordConsumed.serializer)
      ..add(DietRecordMealTypeEnum.serializer)
      ..add(Error.serializer)
      ..add(ErrorError.serializer)
      ..add(ExerciseRecord.serializer)
      ..add(ExerciseType.serializer)
      ..add(Food.serializer)
      ..add(HealthMetric.serializer)
      ..add(HealthRecord.serializer)
      ..add(MoodRecord.serializer)
      ..add(MoodRecordMoodEnum.serializer)
      ..add(MoodTrendPoint.serializer)
      ..add(PublicUser.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ApiHealthRecordsPostRequestRecordsInner)]),
          () => ListBuilder<ApiHealthRecordsPostRequestRecordsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatMessage)]),
          () => ListBuilder<ChatMessage>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DietRecord)]),
          () => ListBuilder<DietRecord>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ExerciseRecord)]),
          () => ListBuilder<ExerciseRecord>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ExerciseType)]),
          () => ListBuilder<ExerciseType>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Food)]),
          () => ListBuilder<Food>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(HealthRecord)]),
          () => ListBuilder<HealthRecord>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MoodRecord)]),
          () => ListBuilder<MoodRecord>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MoodTrendPoint)]),
          () => ListBuilder<MoodTrendPoint>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(DailyNutritionSummaryByMealValue)
          ]),
          () => MapBuilder<String, DailyNutritionSummaryByMealValue>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
