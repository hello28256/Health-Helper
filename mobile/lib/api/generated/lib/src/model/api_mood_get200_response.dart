// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/mood_record.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_mood_get200_response.g.dart';

/// ApiMoodGet200Response
///
/// Properties:
/// * [records] 
@BuiltValue()
abstract class ApiMoodGet200Response implements Built<ApiMoodGet200Response, ApiMoodGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'records')
  BuiltList<MoodRecord>? get records;

  ApiMoodGet200Response._();

  factory ApiMoodGet200Response([void updates(ApiMoodGet200ResponseBuilder b)]) = _$ApiMoodGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiMoodGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiMoodGet200Response> get serializer => _$ApiMoodGet200ResponseSerializer();
}

class _$ApiMoodGet200ResponseSerializer implements PrimitiveSerializer<ApiMoodGet200Response> {
  @override
  final Iterable<Type> types = const [ApiMoodGet200Response, _$ApiMoodGet200Response];

  @override
  final String wireName = r'ApiMoodGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiMoodGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.records != null) {
      yield r'records';
      yield serializers.serialize(
        object.records,
        specifiedType: const FullType(BuiltList, [FullType(MoodRecord)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiMoodGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiMoodGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MoodRecord)]),
          ) as BuiltList<MoodRecord>;
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
  ApiMoodGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiMoodGet200ResponseBuilder();
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

