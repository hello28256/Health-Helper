// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_record_consumed.g.dart';

/// 服务端按 servings × servingSizeG/100 × per100g 计算
///
/// Properties:
/// * [kcal] 
/// * [proteinG] 
/// * [fatG] 
/// * [carbsG] 
/// * [fiberG] 
/// * [sodiumMg] 
@BuiltValue()
abstract class DietRecordConsumed implements Built<DietRecordConsumed, DietRecordConsumedBuilder> {
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

  DietRecordConsumed._();

  factory DietRecordConsumed([void updates(DietRecordConsumedBuilder b)]) = _$DietRecordConsumed;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietRecordConsumedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietRecordConsumed> get serializer => _$DietRecordConsumedSerializer();
}

class _$DietRecordConsumedSerializer implements PrimitiveSerializer<DietRecordConsumed> {
  @override
  final Iterable<Type> types = const [DietRecordConsumed, _$DietRecordConsumed];

  @override
  final String wireName = r'DietRecordConsumed';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietRecordConsumed object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DietRecordConsumed object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietRecordConsumedBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietRecordConsumed deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietRecordConsumedBuilder();
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

