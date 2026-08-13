// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/diet_record.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_diet_records_get200_response.g.dart';

/// ApiDietRecordsGet200Response
///
/// Properties:
/// * [records] 
@BuiltValue()
abstract class ApiDietRecordsGet200Response implements Built<ApiDietRecordsGet200Response, ApiDietRecordsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'records')
  BuiltList<DietRecord>? get records;

  ApiDietRecordsGet200Response._();

  factory ApiDietRecordsGet200Response([void updates(ApiDietRecordsGet200ResponseBuilder b)]) = _$ApiDietRecordsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiDietRecordsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiDietRecordsGet200Response> get serializer => _$ApiDietRecordsGet200ResponseSerializer();
}

class _$ApiDietRecordsGet200ResponseSerializer implements PrimitiveSerializer<ApiDietRecordsGet200Response> {
  @override
  final Iterable<Type> types = const [ApiDietRecordsGet200Response, _$ApiDietRecordsGet200Response];

  @override
  final String wireName = r'ApiDietRecordsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiDietRecordsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.records != null) {
      yield r'records';
      yield serializers.serialize(
        object.records,
        specifiedType: const FullType(BuiltList, [FullType(DietRecord)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiDietRecordsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiDietRecordsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DietRecord)]),
          ) as BuiltList<DietRecord>;
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
  ApiDietRecordsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiDietRecordsGet200ResponseBuilder();
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

