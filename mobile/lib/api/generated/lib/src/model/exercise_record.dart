// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercise_record.g.dart';

/// ExerciseRecord
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [typeId] 
/// * [startedAt] 
/// * [durationSec] 
/// * [distanceKm] 
/// * [calories] - 服务端按 MET × weightKg × duration 计算
/// * [createdAt] 
@BuiltValue()
abstract class ExerciseRecord implements Built<ExerciseRecord, ExerciseRecordBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'userId')
  String? get userId;

  @BuiltValueField(wireName: r'typeId')
  String? get typeId;

  @BuiltValueField(wireName: r'startedAt')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'durationSec')
  int? get durationSec;

  @BuiltValueField(wireName: r'distanceKm')
  num? get distanceKm;

  /// 服务端按 MET × weightKg × duration 计算
  @BuiltValueField(wireName: r'calories')
  num? get calories;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  ExerciseRecord._();

  factory ExerciseRecord([void updates(ExerciseRecordBuilder b)]) = _$ExerciseRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciseRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciseRecord> get serializer => _$ExerciseRecordSerializer();
}

class _$ExerciseRecordSerializer implements PrimitiveSerializer<ExerciseRecord> {
  @override
  final Iterable<Type> types = const [ExerciseRecord, _$ExerciseRecord];

  @override
  final String wireName = r'ExerciseRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciseRecord object, {
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
    if (object.typeId != null) {
      yield r'typeId';
      yield serializers.serialize(
        object.typeId,
        specifiedType: const FullType(String),
      );
    }
    if (object.startedAt != null) {
      yield r'startedAt';
      yield serializers.serialize(
        object.startedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.durationSec != null) {
      yield r'durationSec';
      yield serializers.serialize(
        object.durationSec,
        specifiedType: const FullType(int),
      );
    }
    if (object.distanceKm != null) {
      yield r'distanceKm';
      yield serializers.serialize(
        object.distanceKm,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.calories != null) {
      yield r'calories';
      yield serializers.serialize(
        object.calories,
        specifiedType: const FullType(num),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciseRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciseRecordBuilder result,
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
        case r'typeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.typeId = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'durationSec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSec = valueDes;
          break;
        case r'distanceKm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.distanceKm = valueDes;
          break;
        case r'calories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.calories = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciseRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciseRecordBuilder();
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

