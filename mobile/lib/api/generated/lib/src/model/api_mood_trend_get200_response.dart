// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/mood_trend_point.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_mood_trend_get200_response.g.dart';

/// ApiMoodTrendGet200Response
///
/// Properties:
/// * [trend] 
@BuiltValue()
abstract class ApiMoodTrendGet200Response implements Built<ApiMoodTrendGet200Response, ApiMoodTrendGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'trend')
  BuiltList<MoodTrendPoint>? get trend;

  ApiMoodTrendGet200Response._();

  factory ApiMoodTrendGet200Response([void updates(ApiMoodTrendGet200ResponseBuilder b)]) = _$ApiMoodTrendGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiMoodTrendGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiMoodTrendGet200Response> get serializer => _$ApiMoodTrendGet200ResponseSerializer();
}

class _$ApiMoodTrendGet200ResponseSerializer implements PrimitiveSerializer<ApiMoodTrendGet200Response> {
  @override
  final Iterable<Type> types = const [ApiMoodTrendGet200Response, _$ApiMoodTrendGet200Response];

  @override
  final String wireName = r'ApiMoodTrendGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiMoodTrendGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.trend != null) {
      yield r'trend';
      yield serializers.serialize(
        object.trend,
        specifiedType: const FullType(BuiltList, [FullType(MoodTrendPoint)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiMoodTrendGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiMoodTrendGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MoodTrendPoint)]),
          ) as BuiltList<MoodTrendPoint>;
          result.trend.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiMoodTrendGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiMoodTrendGet200ResponseBuilder();
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

