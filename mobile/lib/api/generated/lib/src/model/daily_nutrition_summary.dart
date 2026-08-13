// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/daily_nutrition_summary_by_meal_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'daily_nutrition_summary.g.dart';

/// DailyNutritionSummary
///
/// Properties:
/// * [date] 
/// * [kcal] 
/// * [proteinG] 
/// * [fatG] 
/// * [carbsG] 
/// * [fiberG] 
/// * [sodiumMg] 
/// * [recordCount] 
/// * [byMeal] 
@BuiltValue()
abstract class DailyNutritionSummary implements Built<DailyNutritionSummary, DailyNutritionSummaryBuilder> {
  @BuiltValueField(wireName: r'date')
  String? get date;

  @BuiltValueField(wireName: r'kcal')
  num? get kcal;

  @BuiltValueField(wireName: r'proteinG')
  num? get proteinG;

  @BuiltValueField(wireName: r'fatG')
  num? get fatG;

  @BuiltValueField(wireName: r'carbsG')
  num? get carbsG;

  @BuiltValueField(wireName: r'fiberG')
  num? get fiberG;

  @BuiltValueField(wireName: r'sodiumMg')
  num? get sodiumMg;

  @BuiltValueField(wireName: r'recordCount')
  int? get recordCount;

  @BuiltValueField(wireName: r'byMeal')
  BuiltMap<String, DailyNutritionSummaryByMealValue>? get byMeal;

  DailyNutritionSummary._();

  factory DailyNutritionSummary([void updates(DailyNutritionSummaryBuilder b)]) = _$DailyNutritionSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DailyNutritionSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DailyNutritionSummary> get serializer => _$DailyNutritionSummarySerializer();
}

class _$DailyNutritionSummarySerializer implements PrimitiveSerializer<DailyNutritionSummary> {
  @override
  final Iterable<Type> types = const [DailyNutritionSummary, _$DailyNutritionSummary];

  @override
  final String wireName = r'DailyNutritionSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DailyNutritionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.date != null) {
      yield r'date';
      yield serializers.serialize(
        object.date,
        specifiedType: const FullType(String),
      );
    }
    if (object.kcal != null) {
      yield r'kcal';
      yield serializers.serialize(
        object.kcal,
        specifiedType: const FullType(num),
      );
    }
    if (object.proteinG != null) {
      yield r'proteinG';
      yield serializers.serialize(
        object.proteinG,
        specifiedType: const FullType(num),
      );
    }
    if (object.fatG != null) {
      yield r'fatG';
      yield serializers.serialize(
        object.fatG,
        specifiedType: const FullType(num),
      );
    }
    if (object.carbsG != null) {
      yield r'carbsG';
      yield serializers.serialize(
        object.carbsG,
        specifiedType: const FullType(num),
      );
    }
    if (object.fiberG != null) {
      yield r'fiberG';
      yield serializers.serialize(
        object.fiberG,
        specifiedType: const FullType(num),
      );
    }
    if (object.sodiumMg != null) {
      yield r'sodiumMg';
      yield serializers.serialize(
        object.sodiumMg,
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
    if (object.byMeal != null) {
      yield r'byMeal';
      yield serializers.serialize(
        object.byMeal,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(DailyNutritionSummaryByMealValue)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DailyNutritionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DailyNutritionSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'kcal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.kcal = valueDes;
          break;
        case r'proteinG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.proteinG = valueDes;
          break;
        case r'fatG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.fatG = valueDes;
          break;
        case r'carbsG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.carbsG = valueDes;
          break;
        case r'fiberG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.fiberG = valueDes;
          break;
        case r'sodiumMg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.sodiumMg = valueDes;
          break;
        case r'recordCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recordCount = valueDes;
          break;
        case r'byMeal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(DailyNutritionSummaryByMealValue)]),
          ) as BuiltMap<String, DailyNutritionSummaryByMealValue>;
          result.byMeal.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DailyNutritionSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DailyNutritionSummaryBuilder();
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

