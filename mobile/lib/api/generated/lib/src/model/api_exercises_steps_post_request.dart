// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_exercises_steps_post_request.g.dart';

/// ApiExercisesStepsPostRequest
///
/// Properties:
/// * [date] - 默认今天
/// * [steps] 
/// * [source_] 
@BuiltValue()
abstract class ApiExercisesStepsPostRequest implements Built<ApiExercisesStepsPostRequest, ApiExercisesStepsPostRequestBuilder> {
  /// 默认今天
  @BuiltValueField(wireName: r'date')
  DateTime? get date;

  @BuiltValueField(wireName: r'steps')
  int get steps;

  @BuiltValueField(wireName: r'source')
  ApiExercisesStepsPostRequestSource_Enum? get source_;
  // enum source_Enum {  ios_pedometer,  android_sensor,  manual,  };

  ApiExercisesStepsPostRequest._();

  factory ApiExercisesStepsPostRequest([void updates(ApiExercisesStepsPostRequestBuilder b)]) = _$ApiExercisesStepsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiExercisesStepsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiExercisesStepsPostRequest> get serializer => _$ApiExercisesStepsPostRequestSerializer();
}

class _$ApiExercisesStepsPostRequestSerializer implements PrimitiveSerializer<ApiExercisesStepsPostRequest> {
  @override
  final Iterable<Type> types = const [ApiExercisesStepsPostRequest, _$ApiExercisesStepsPostRequest];

  @override
  final String wireName = r'ApiExercisesStepsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiExercisesStepsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.date != null) {
      yield r'date';
      yield serializers.serialize(
        object.date,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(int),
    );
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType(ApiExercisesStepsPostRequestSource_Enum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiExercisesStepsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiExercisesStepsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.date = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.steps = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiExercisesStepsPostRequestSource_Enum),
          ) as ApiExercisesStepsPostRequestSource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiExercisesStepsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiExercisesStepsPostRequestBuilder();
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

class ApiExercisesStepsPostRequestSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ios_pedometer')
  static const ApiExercisesStepsPostRequestSource_Enum iosPedometer = _$apiExercisesStepsPostRequestSourceEnum_iosPedometer;
  @BuiltValueEnumConst(wireName: r'android_sensor')
  static const ApiExercisesStepsPostRequestSource_Enum androidSensor = _$apiExercisesStepsPostRequestSourceEnum_androidSensor;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ApiExercisesStepsPostRequestSource_Enum manual = _$apiExercisesStepsPostRequestSourceEnum_manual;

  static Serializer<ApiExercisesStepsPostRequestSource_Enum> get serializer => _$apiExercisesStepsPostRequestSourceEnumSerializer;

  const ApiExercisesStepsPostRequestSource_Enum._(String name): super(name);

  static BuiltSet<ApiExercisesStepsPostRequestSource_Enum> get values => _$apiExercisesStepsPostRequestSourceEnumValues;
  static ApiExercisesStepsPostRequestSource_Enum valueOf(String name) => _$apiExercisesStepsPostRequestSourceEnumValueOf(name);
}

