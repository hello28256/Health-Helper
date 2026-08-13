// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_nutrition_summary_by_meal_value.g.dart';

/// DailyNutritionSummaryByMealValue
///
/// Properties:
/// * [kcal] 
/// * [recordCount] 
@BuiltValue()
abstract class DailyNutritionSummaryByMealValue implements Built<DailyNutritionSummaryByMealValue, DailyNutritionSummaryByMealValueBuilder> {
  @BuiltValueField(wireName: r'kcal')
  num? get kcal;

  @BuiltValueField(wireName: r'recordCount')
  int? get recordCount;

  DailyNutritionSummaryByMealValue._();

  factory DailyNutritionSummaryByMealValue([void updates(DailyNutritionSummaryByMealValueBuilder b)]) = _$DailyNutritionSummaryByMealValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyNutritionSummaryByMealValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyNutritionSummaryByMealValue> get serializer => _$DailyNutritionSummaryByMealValueSerializer();
}

class _$DailyNutritionSummaryByMealValueSerializer implements PrimitiveSerializer<DailyNutritionSummaryByMealValue> {
  @override
  final Iterable<Type> types = const [DailyNutritionSummaryByMealValue, _$DailyNutritionSummaryByMealValue];

  @override
  final String wireName = r'DailyNutritionSummaryByMealValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyNutritionSummaryByMealValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.kcal != null) {
      yield r'kcal';
      yield serializers.serialize(
        object.kcal,
        specifiedType: const FullType(num),
      );
    }
    if (object.recordCount != null) {
      yield r'recordCount';
      yield serializers.serialize(
        object.recordCount,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyNutritionSummaryByMealValue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DailyNutritionSummaryByMealValueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kcal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.kcal = valueDes;
          break;
        case r'recordCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recordCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DailyNutritionSummaryByMealValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyNutritionSummaryByMealValueBuilder();
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

