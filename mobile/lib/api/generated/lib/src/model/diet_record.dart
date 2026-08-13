// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:health_helper_api/src/model/food.dart';
import 'package:built_collection/built_collection.dart';
import 'package:health_helper_api/src/model/diet_record_consumed.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_record.g.dart';

/// DietRecord
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [foodId] 
/// * [mealType] 
/// * [consumedAt] 
/// * [servings] 
/// * [food] 
/// * [consumed] 
@BuiltValue()
abstract class DietRecord implements Built<DietRecord, DietRecordBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'userId')
  String? get userId;

  @BuiltValueField(wireName: r'foodId')
  int? get foodId;

  @BuiltValueField(wireName: r'mealType')
  DietRecordMealTypeEnum? get mealType;
  // enum mealTypeEnum {  breakfast,  lunch,  dinner,  snack,  };

  @BuiltValueField(wireName: r'consumedAt')
  DateTime? get consumedAt;

  @BuiltValueField(wireName: r'servings')
  num? get servings;

  @BuiltValueField(wireName: r'food')
  Food? get food;

  @BuiltValueField(wireName: r'consumed')
  DietRecordConsumed? get consumed;

  DietRecord._();

  factory DietRecord([void updates(DietRecordBuilder b)]) = _$DietRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietRecord> get serializer => _$DietRecordSerializer();
}

class _$DietRecordSerializer implements PrimitiveSerializer<DietRecord> {
  @override
  final Iterable<Type> types = const [DietRecord, _$DietRecord];

  @override
  final String wireName = r'DietRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
    if (object.foodId != null) {
      yield r'foodId';
      yield serializers.serialize(
        object.foodId,
        specifiedType: const FullType(int),
      );
    }
    if (object.mealType != null) {
      yield r'mealType';
      yield serializers.serialize(
        object.mealType,
        specifiedType: const FullType(DietRecordMealTypeEnum),
      );
    }
    if (object.consumedAt != null) {
      yield r'consumedAt';
      yield serializers.serialize(
        object.consumedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.servings != null) {
      yield r'servings';
      yield serializers.serialize(
        object.servings,
        specifiedType: const FullType(num),
      );
    }
    if (object.food != null) {
      yield r'food';
      yield serializers.serialize(
        object.food,
        specifiedType: const FullType(Food),
      );
    }
    if (object.consumed != null) {
      yield r'consumed';
      yield serializers.serialize(
        object.consumed,
        specifiedType: const FullType(DietRecordConsumed),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'foodId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.foodId = valueDes;
          break;
        case r'mealType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DietRecordMealTypeEnum),
          ) as DietRecordMealTypeEnum;
          result.mealType = valueDes;
          break;
        case r'consumedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.consumedAt = valueDes;
          break;
        case r'servings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.servings = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Food),
          ) as Food;
          result.food.replace(valueDes);
          break;
        case r'consumed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DietRecordConsumed),
          ) as DietRecordConsumed;
          result.consumed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietRecordBuilder();
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

class DietRecordMealTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'breakfast')
  static const DietRecordMealTypeEnum breakfast = _$dietRecordMealTypeEnum_breakfast;
  @BuiltValueEnumConst(wireName: r'lunch')
  static const DietRecordMealTypeEnum lunch = _$dietRecordMealTypeEnum_lunch;
  @BuiltValueEnumConst(wireName: r'dinner')
  static const DietRecordMealTypeEnum dinner = _$dietRecordMealTypeEnum_dinner;
  @BuiltValueEnumConst(wireName: r'snack')
  static const DietRecordMealTypeEnum snack = _$dietRecordMealTypeEnum_snack;

  static Serializer<DietRecordMealTypeEnum> get serializer => _$dietRecordMealTypeEnumSerializer;

  const DietRecordMealTypeEnum._(String name): super(name);

  static BuiltSet<DietRecordMealTypeEnum> get values => _$dietRecordMealTypeEnumValues;
  static DietRecordMealTypeEnum valueOf(String name) => _$dietRecordMealTypeEnumValueOf(name);
}

