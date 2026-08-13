// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mood_record.g.dart';

/// MoodRecord
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [mood] 
/// * [score] 
/// * [note] 
/// * [recordedAt] 
@BuiltValue()
abstract class MoodRecord implements Built<MoodRecord, MoodRecordBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'userId')
  String? get userId;

  @BuiltValueField(wireName: r'mood')
  MoodRecordMoodEnum? get mood;
  // enum moodEnum {  happy,  calm,  sad,  anxious,  angry,  tired,  grateful,  excited,  };

  @BuiltValueField(wireName: r'score')
  int? get score;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime? get recordedAt;

  MoodRecord._();

  factory MoodRecord([void updates(MoodRecordBuilder b)]) = _$MoodRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MoodRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MoodRecord> get serializer => _$MoodRecordSerializer();
}

class _$MoodRecordSerializer implements PrimitiveSerializer<MoodRecord> {
  @override
  final Iterable<Type> types = const [MoodRecord, _$MoodRecord];

  @override
  final String wireName = r'MoodRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MoodRecord object, {
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
    if (object.mood != null) {
      yield r'mood';
      yield serializers.serialize(
        object.mood,
        specifiedType: const FullType(MoodRecordMoodEnum),
      );
    }
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.recordedAt != null) {
      yield r'recordedAt';
      yield serializers.serialize(
        object.recordedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MoodRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MoodRecordBuilder result,
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
        case r'mood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoodRecordMoodEnum),
          ) as MoodRecordMoodEnum;
          result.mood = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.score = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'recordedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MoodRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MoodRecordBuilder();
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

class MoodRecordMoodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'happy')
  static const MoodRecordMoodEnum happy = _$moodRecordMoodEnum_happy;
  @BuiltValueEnumConst(wireName: r'calm')
  static const MoodRecordMoodEnum calm = _$moodRecordMoodEnum_calm;
  @BuiltValueEnumConst(wireName: r'sad')
  static const MoodRecordMoodEnum sad = _$moodRecordMoodEnum_sad;
  @BuiltValueEnumConst(wireName: r'anxious')
  static const MoodRecordMoodEnum anxious = _$moodRecordMoodEnum_anxious;
  @BuiltValueEnumConst(wireName: r'angry')
  static const MoodRecordMoodEnum angry = _$moodRecordMoodEnum_angry;
  @BuiltValueEnumConst(wireName: r'tired')
  static const MoodRecordMoodEnum tired = _$moodRecordMoodEnum_tired;
  @BuiltValueEnumConst(wireName: r'grateful')
  static const MoodRecordMoodEnum grateful = _$moodRecordMoodEnum_grateful;
  @BuiltValueEnumConst(wireName: r'excited')
  static const MoodRecordMoodEnum excited = _$moodRecordMoodEnum_excited;

  static Serializer<MoodRecordMoodEnum> get serializer => _$moodRecordMoodEnumSerializer;

  const MoodRecordMoodEnum._(String name): super(name);

  static BuiltSet<MoodRecordMoodEnum> get values => _$moodRecordMoodEnumValues;
  static MoodRecordMoodEnum valueOf(String name) => _$moodRecordMoodEnumValueOf(name);
}

