// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_exercises_post_request.g.dart';

/// ApiExercisesPostRequest
///
/// Properties:
/// * [typeId] 
/// * [startedAt] 
/// * [durationSec] 
/// * [distanceKm] 
/// * [clientId] - 幂等键（避免重复上报）
@BuiltValue()
abstract class ApiExercisesPostRequest implements Built<ApiExercisesPostRequest, ApiExercisesPostRequestBuilder> {
  @BuiltValueField(wireName: r'typeId')
  String get typeId;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'durationSec')
  int get durationSec;

  @BuiltValueField(wireName: r'distanceKm')
  num? get distanceKm;

  /// 幂等键（避免重复上报）
  @BuiltValueField(wireName: r'clientId')
  String? get clientId;

  ApiExercisesPostRequest._();

  factory ApiExercisesPostRequest([void updates(ApiExercisesPostRequestBuilder b)]) = _$ApiExercisesPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiExercisesPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiExercisesPostRequest> get serializer => _$ApiExercisesPostRequestSerializer();
}

class _$ApiExercisesPostRequestSerializer implements PrimitiveSerializer<ApiExercisesPostRequest> {
  @override
  final Iterable<Type> types = const [ApiExercisesPostRequest, _$ApiExercisesPostRequest];

  @override
  final String wireName = r'ApiExercisesPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiExercisesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'typeId';
    yield serializers.serialize(
      object.typeId,
      specifiedType: const FullType(String),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'durationSec';
    yield serializers.serialize(
      object.durationSec,
      specifiedType: const FullType(int),
    );
    if (object.distanceKm != null) {
      yield r'distanceKm';
      yield serializers.serialize(
        object.distanceKm,
        specifiedType: const FullType(num),
      );
    }
    if (object.clientId != null) {
      yield r'clientId';
      yield serializers.serialize(
        object.clientId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiExercisesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiExercisesPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'typeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.typeId = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'durationSec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSec = valueDes;
          break;
        case r'distanceKm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.distanceKm = valueDes;
          break;
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiExercisesPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiExercisesPostRequestBuilder();
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

