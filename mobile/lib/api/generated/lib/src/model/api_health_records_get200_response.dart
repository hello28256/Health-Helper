// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:health_helper_api/src/model/health_record.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_health_records_get200_response.g.dart';

/// ApiHealthRecordsGet200Response
///
/// Properties:
/// * [records] 
@BuiltValue()
abstract class ApiHealthRecordsGet200Response implements Built<ApiHealthRecordsGet200Response, ApiHealthRecordsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'records')
  BuiltList<HealthRecord>? get records;

  ApiHealthRecordsGet200Response._();

  factory ApiHealthRecordsGet200Response([void updates(ApiHealthRecordsGet200ResponseBuilder b)]) = _$ApiHealthRecordsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiHealthRecordsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiHealthRecordsGet200Response> get serializer => _$ApiHealthRecordsGet200ResponseSerializer();
}

class _$ApiHealthRecordsGet200ResponseSerializer implements PrimitiveSerializer<ApiHealthRecordsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiHealthRecordsGet200Response, _$ApiHealthRecordsGet200Response];

  @override
  final String wireName = r'ApiHealthRecordsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiHealthRecordsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.records != null) {
      yield r'records';
      yield serializers.serialize(
        object.records,
        specifiedType: const FullType(BuiltList, [FullType(HealthRecord)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiHealthRecordsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiHealthRecordsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(HealthRecord)]),
          ) as BuiltList<HealthRecord>;
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
  ApiHealthRecordsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiHealthRecordsGet200ResponseBuilder();
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

