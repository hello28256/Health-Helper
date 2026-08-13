// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/exercise_record.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_exercises_get200_response.g.dart';

/// ApiExercisesGet200Response
///
/// Properties:
/// * [records] 
@BuiltValue()
abstract class ApiExercisesGet200Response implements Built<ApiExercisesGet200Response, ApiExercisesGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'records')
  BuiltList<ExerciseRecord>? get records;

  ApiExercisesGet200Response._();

  factory ApiExercisesGet200Response([void updates(ApiExercisesGet200ResponseBuilder b)]) = _$ApiExercisesGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiExercisesGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiExercisesGet200Response> get serializer => _$ApiExercisesGet200ResponseSerializer();
}

class _$ApiExercisesGet200ResponseSerializer implements PrimitiveSerializer<ApiExercisesGet200Response> {
  @override
  final Iterable<Type> types = const [ApiExercisesGet200Response, _$ApiExercisesGet200Response];

  @override
  final String wireName = r'ApiExercisesGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiExercisesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.records != null) {
      yield r'records';
      yield serializers.serialize(
        object.records,
        specifiedType: const FullType(BuiltList, [FullType(ExerciseRecord)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiExercisesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiExercisesGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ExerciseRecord)]),
          ) as BuiltList<ExerciseRecord>;
          result.records.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiExercisesGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiExercisesGet200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

