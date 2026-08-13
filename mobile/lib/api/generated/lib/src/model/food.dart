// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'food.g.dart';

/// Food
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [nameZh] 
/// * [category] 
/// * [servingSizeG] 
/// * [kcalPer100g] 
/// * [proteinG] 
/// * [fatG] 
/// * [carbsG] 
/// * [fiberG] 
/// * [sodiumMg] 
@BuiltValue()
abstract class Food implements Built<Food, FoodBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'nameZh')
  String? get nameZh;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'servingSizeG')
  num? get servingSizeG;

  @BuiltValueField(wireName: r'kcalPer100g')
  num? get kcalPer100g;

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

  Food._();

  factory Food([void updates(FoodBuilder b)]) = _$Food;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Food> get serializer => _$FoodSerializer();
}

class _$FoodSerializer implements PrimitiveSerializer<Food> {
  @override
  final Iterable<Type> types = const [Food, _$Food];

  @override
  final String wireName = r'Food';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Food object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.nameZh != null) {
      yield r'nameZh';
      yield serializers.serialize(
        object.nameZh,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.servingSizeG != null) {
      yield r'servingSizeG';
      yield serializers.serialize(
        object.servingSizeG,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.kcalPer100g != null) {
      yield r'kcalPer100g';
      yield serializers.serialize(
        object.kcalPer100g,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.proteinG != null) {
      yield r'proteinG';
      yield serializers.serialize(
        object.proteinG,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.fatG != null) {
      yield r'fatG';
      yield serializers.serialize(
        object.fatG,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.carbsG != null) {
      yield r'carbsG';
      yield serializers.serialize(
        object.carbsG,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.fiberG != null) {
      yield r'fiberG';
      yield serializers.serialize(
        object.fiberG,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.sodiumMg != null) {
      yield r'sodiumMg';
      yield serializers.serialize(
        object.sodiumMg,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Food object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FoodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'nameZh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nameZh = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'servingSizeG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.servingSizeG = valueDes;
          break;
        case r'kcalPer100g':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.kcalPer100g = valueDes;
          break;
        case r'proteinG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.proteinG = valueDes;
          break;
        case r'fatG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.fatG = valueDes;
          break;
        case r'carbsG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.carbsG = valueDes;
          break;
        case r'fiberG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.fiberG = valueDes;
          break;
        case r'sodiumMg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.sodiumMg = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Food deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoodBuilder();
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

