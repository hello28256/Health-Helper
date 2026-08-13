// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:health_helper_api/src/model/exercise_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_exercises_types_get200_response.g.dart';

/// ApiExercisesTypesGet200Response
///
/// Properties:
/// * [types] 
@BuiltValue()
abstract class ApiExercisesTypesGet200Response implements Built<ApiExercisesTypesGet200Response, ApiExercisesTypesGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'types')
  BuiltList<ExerciseType>? get types;

  ApiExercisesTypesGet200Response._();

  factory ApiExercisesTypesGet200Response([void updates(ApiExercisesTypesGet200ResponseBuilder b)]) = _$ApiExercisesTypesGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiExercisesTypesGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiExercisesTypesGet200Response> get serializer => _$ApiExercisesTypesGet200ResponseSerializer();
}

class _$ApiExercisesTypesGet200ResponseSerializer implements PrimitiveSerializer<ApiExercisesTypesGet200Response> {
  @override
  final Iterable<Type> types = const [ApiExercisesTypesGet200Response, _$ApiExercisesTypesGet200Response];

  @override
  final String wireName = r'ApiExercisesTypesGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiExercisesTypesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.types != null) {
      yield r'types';
      yield serializers.serialize(
        object.types,
        specifiedType: const FullType(BuiltList, [FullType(ExerciseType)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiExercisesTypesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiExercisesTypesGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ExerciseType)]),
          ) as BuiltList<ExerciseType>;
          result.types.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiExercisesTypesGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiExercisesTypesGet200ResponseBuilder();
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

