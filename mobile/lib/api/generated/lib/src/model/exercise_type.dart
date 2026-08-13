// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercise_type.g.dart';

/// ExerciseType
///
/// Properties:
/// * [id] 
/// * [displayNameZh] 
/// * [displayNameEn] 
/// * [met] - 代谢当量 MET，用于卡路里计算
/// * [notes] - 运动安全注意事项
@BuiltValue()
abstract class ExerciseType implements Built<ExerciseType, ExerciseTypeBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'displayNameZh')
  String? get displayNameZh;

  @BuiltValueField(wireName: r'displayNameEn')
  String? get displayNameEn;

  /// 代谢当量 MET，用于卡路里计算
  @BuiltValueField(wireName: r'met')
  num? get met;

  /// 运动安全注意事项
  @BuiltValueField(wireName: r'notes')
  String? get notes;

  ExerciseType._();

  factory ExerciseType([void updates(ExerciseTypeBuilder b)]) = _$ExerciseType;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciseTypeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciseType> get serializer => _$ExerciseTypeSerializer();
}

class _$ExerciseTypeSerializer implements PrimitiveSerializer<ExerciseType> {
  @override
  final Iterable<Type> types = const [ExerciseType, _$ExerciseType];

  @override
  final String wireName = r'ExerciseType';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciseType object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayNameZh != null) {
      yield r'displayNameZh';
      yield serializers.serialize(
        object.displayNameZh,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayNameEn != null) {
      yield r'displayNameEn';
      yield serializers.serialize(
        object.displayNameEn,
        specifiedType: const FullType(String),
      );
    }
    if (object.met != null) {
      yield r'met';
      yield serializers.serialize(
        object.met,
        specifiedType: const FullType(num),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciseType object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciseTypeBuilder result,
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
        case r'displayNameZh':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayNameZh = valueDes;
          break;
        case r'displayNameEn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayNameEn = valueDes;
          break;
        case r'met':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.met = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciseType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciseTypeBuilder();
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

