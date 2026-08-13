// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/api_health_records_post_request_records_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_health_records_post_request.g.dart';

/// ApiHealthRecordsPostRequest
///
/// Properties:
/// * [records] 
@BuiltValue()
abstract class ApiHealthRecordsPostRequest implements Built<ApiHealthRecordsPostRequest, ApiHealthRecordsPostRequestBuilder> {
  @BuiltValueField(wireName: r'records')
  BuiltList<ApiHealthRecordsPostRequestRecordsInner> get records;

  ApiHealthRecordsPostRequest._();

  factory ApiHealthRecordsPostRequest([void updates(ApiHealthRecordsPostRequestBuilder b)]) = _$ApiHealthRecordsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiHealthRecordsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiHealthRecordsPostRequest> get serializer => _$ApiHealthRecordsPostRequestSerializer();
}

class _$ApiHealthRecordsPostRequestSerializer implements PrimitiveSerializer<ApiHealthRecordsPostRequest> {
  @override
  final Iterable<Type> types = const [ApiHealthRecordsPostRequest, _$ApiHealthRecordsPostRequest];

  @override
  final String wireName = r'ApiHealthRecordsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiHealthRecordsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'records';
    yield serializers.serialize(
      object.records,
      specifiedType: const FullType(BuiltList, [FullType(ApiHealthRecordsPostRequestRecordsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiHealthRecordsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiHealthRecordsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiHealthRecordsPostRequestRecordsInner)]),
          ) as BuiltList<ApiHealthRecordsPostRequestRecordsInner>;
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
  ApiHealthRecordsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiHealthRecordsPostRequestBuilder();
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

