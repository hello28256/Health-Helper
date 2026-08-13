// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/health_metric.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_health_records_post_request_records_inner.g.dart';

/// ApiHealthRecordsPostRequestRecordsInner
///
/// Properties:
/// * [metric] 
/// * [value] 
/// * [unit] 
/// * [startAt] 
/// * [endAt] 
/// * [source_] 
/// * [raw] 
@BuiltValue()
abstract class ApiHealthRecordsPostRequestRecordsInner implements Built<ApiHealthRecordsPostRequestRecordsInner, ApiHealthRecordsPostRequestRecordsInnerBuilder> {
  @BuiltValueField(wireName: r'metric')
  HealthMetric get metric;
  // enum metricEnum {  steps,  heart_rate,  sleep,  weight,  blood_pressure,  blood_glucose,  spo2,  body_temperature,  };

  @BuiltValueField(wireName: r'value')
  num get value;

  @BuiltValueField(wireName: r'unit')
  String get unit;

  @BuiltValueField(wireName: r'startAt')
  DateTime get startAt;

  @BuiltValueField(wireName: r'endAt')
  DateTime? get endAt;

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'raw')
  BuiltMap<String, JsonObject?>? get raw;

  ApiHealthRecordsPostRequestRecordsInner._();

  factory ApiHealthRecordsPostRequestRecordsInner([void updates(ApiHealthRecordsPostRequestRecordsInnerBuilder b)]) = _$ApiHealthRecordsPostRequestRecordsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiHealthRecordsPostRequestRecordsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiHealthRecordsPostRequestRecordsInner> get serializer => _$ApiHealthRecordsPostRequestRecordsInnerSerializer();
}

class _$ApiHealthRecordsPostRequestRecordsInnerSerializer implements PrimitiveSerializer<ApiHealthRecordsPostRequestRecordsInner> {
  @override
  final Iterable<Type> types = const [ApiHealthRecordsPostRequestRecordsInner, _$ApiHealthRecordsPostRequestRecordsInner];

  @override
  final String wireName = r'ApiHealthRecordsPostRequestRecordsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiHealthRecordsPostRequestRecordsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'metric';
    yield serializers.serialize(
      object.metric,
      specifiedType: const FullType(HealthMetric),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(num),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(String),
    );
    yield r'startAt';
    yield serializers.serialize(
      object.startAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.endAt != null) {
      yield r'endAt';
      yield serializers.serialize(
        object.endAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
    if (object.raw != null) {
      yield r'raw';
      yield serializers.serialize(
        object.raw,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiHealthRecordsPostRequestRecordsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiHealthRecordsPostRequestRecordsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metric':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthMetric),
          ) as HealthMetric;
          result.metric = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.value = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unit = valueDes;
          break;
        case r'startAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startAt = valueDes;
          break;
        case r'endAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endAt = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'raw':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.raw.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiHealthRecordsPostRequestRecordsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiHealthRecordsPostRequestRecordsInnerBuilder();
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

