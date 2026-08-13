// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/health_record.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_health_records_latest_get200_response.g.dart';

/// ApiHealthRecordsLatestGet200Response
///
/// Properties:
/// * [record] 
@BuiltValue()
abstract class ApiHealthRecordsLatestGet200Response implements Built<ApiHealthRecordsLatestGet200Response, ApiHealthRecordsLatestGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'record')
  HealthRecord? get record;

  ApiHealthRecordsLatestGet200Response._();

  factory ApiHealthRecordsLatestGet200Response([void updates(ApiHealthRecordsLatestGet200ResponseBuilder b)]) = _$ApiHealthRecordsLatestGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiHealthRecordsLatestGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiHealthRecordsLatestGet200Response> get serializer => _$ApiHealthRecordsLatestGet200ResponseSerializer();
}

class _$ApiHealthRecordsLatestGet200ResponseSerializer implements PrimitiveSerializer<ApiHealthRecordsLatestGet200Response> {
  @override
  final Iterable<Type> types = const [ApiHealthRecordsLatestGet200Response, _$ApiHealthRecordsLatestGet200Response];

  @override
  final String wireName = r'ApiHealthRecordsLatestGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiHealthRecordsLatestGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.record != null) {
      yield r'record';
      yield serializers.serialize(
        object.record,
        specifiedType: const FullType(HealthRecord),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiHealthRecordsLatestGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiHealthRecordsLatestGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'record':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthRecord),
          ) as HealthRecord;
          result.record.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiHealthRecordsLatestGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiHealthRecordsLatestGet200ResponseBuilder();
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

