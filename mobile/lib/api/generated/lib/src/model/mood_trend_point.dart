// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mood_trend_point.g.dart';

/// MoodTrendPoint
///
/// Properties:
/// * [date] 
/// * [avgScore] 
/// * [recordCount] 
/// * [dominantMood] 
@BuiltValue()
abstract class MoodTrendPoint implements Built<MoodTrendPoint, MoodTrendPointBuilder> {
  @BuiltValueField(wireName: r'date')
  String? get date;

  @BuiltValueField(wireName: r'avgScore')
  num? get avgScore;

  @BuiltValueField(wireName: r'recordCount')
  int? get recordCount;

  @BuiltValueField(wireName: r'dominantMood')
  String? get dominantMood;

  MoodTrendPoint._();

  factory MoodTrendPoint([void updates(MoodTrendPointBuilder b)]) = _$MoodTrendPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MoodTrendPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MoodTrendPoint> get serializer => _$MoodTrendPointSerializer();
}

class _$MoodTrendPointSerializer implements PrimitiveSerializer<MoodTrendPoint> {
  @override
  final Iterable<Type> types = const [MoodTrendPoint, _$MoodTrendPoint];

  @override
  final String wireName = r'MoodTrendPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MoodTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.date != null) {
      yield r'date';
      yield serializers.serialize(
        object.date,
        specifiedType: const FullType(String),
      );
    }
    if (object.avgScore != null) {
      yield r'avgScore';
      yield serializers.serialize(
        object.avgScore,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.recordCount != null) {
      yield r'recordCount';
      yield serializers.serialize(
        object.recordCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.dominantMood != null) {
      yield r'dominantMood';
      yield serializers.serialize(
        object.dominantMood,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MoodTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MoodTrendPointBuilder result,
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
        case r'avgScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.avgScore = valueDes;
          break;
        case r'recordCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recordCount = valueDes;
          break;
        case r'dominantMood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dominantMood = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MoodTrendPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MoodTrendPointBuilder();
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

