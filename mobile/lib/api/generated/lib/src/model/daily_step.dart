// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_step.g.dart';

/// DailyStep
///
/// Properties:
/// * [userId] 
/// * [date] 
/// * [steps] 
/// * [source_] 
/// * [updatedAt] 
@BuiltValue()
abstract class DailyStep implements Built<DailyStep, DailyStepBuilder> {
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  @BuiltValueField(wireName: r'date')
  String? get date;

  @BuiltValueField(wireName: r'steps')
  int? get steps;

  @BuiltValueField(wireName: r'source')
  DailyStepSource_Enum? get source_;
  // enum source_Enum {  ios_pedometer,  android_sensor,  manual,  };

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  DailyStep._();

  factory DailyStep([void updates(DailyStepBuilder b)]) = _$DailyStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyStepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyStep> get serializer => _$DailyStepSerializer();
}

class _$DailyStepSerializer implements PrimitiveSerializer<DailyStep> {
  @override
  final Iterable<Type> types = const [DailyStep, _$DailyStep];

  @override
  final String wireName = r'DailyStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyStep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
    if (object.date != null) {
      yield r'date';
      yield serializers.serialize(
        object.date,
        specifiedType: const FullType(String),
      );
    }
    if (object.steps != null) {
      yield r'steps';
      yield serializers.serialize(
        object.steps,
        specifiedType: const FullType(int),
      );
    }
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType.nullable(DailyStepSource_Enum),
      );
    }
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyStep object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DailyStepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType.nullable(DailyStepSource_Enum),
          ) as DailyStepSource_Enum?;
          if (valueDes == null) continue;
          result.source_ = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DailyStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyStepBuilder();
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

class DailyStepSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ios_pedometer')
  static const DailyStepSource_Enum iosPedometer = _$dailyStepSourceEnum_iosPedometer;
  @BuiltValueEnumConst(wireName: r'android_sensor')
  static const DailyStepSource_Enum androidSensor = _$dailyStepSourceEnum_androidSensor;
  @BuiltValueEnumConst(wireName: r'manual')
  static const DailyStepSource_Enum manual = _$dailyStepSourceEnum_manual;

  static Serializer<DailyStepSource_Enum> get serializer => _$dailyStepSourceEnumSerializer;

  const DailyStepSource_Enum._(String name): super(name);

  static BuiltSet<DailyStepSource_Enum> get values => _$dailyStepSourceEnumValues;
  static DailyStepSource_Enum valueOf(String name) => _$dailyStepSourceEnumValueOf(name);
}

