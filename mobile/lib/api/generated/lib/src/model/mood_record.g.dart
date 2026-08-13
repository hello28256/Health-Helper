// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MoodRecordMoodEnum _$moodRecordMoodEnum_happy =
    const MoodRecordMoodEnum._('happy');
const MoodRecordMoodEnum _$moodRecordMoodEnum_calm =
    const MoodRecordMoodEnum._('calm');
const MoodRecordMoodEnum _$moodRecordMoodEnum_sad =
    const MoodRecordMoodEnum._('sad');
const MoodRecordMoodEnum _$moodRecordMoodEnum_anxious =
    const MoodRecordMoodEnum._('anxious');
const MoodRecordMoodEnum _$moodRecordMoodEnum_angry =
    const MoodRecordMoodEnum._('angry');
const MoodRecordMoodEnum _$moodRecordMoodEnum_tired =
    const MoodRecordMoodEnum._('tired');
const MoodRecordMoodEnum _$moodRecordMoodEnum_grateful =
    const MoodRecordMoodEnum._('grateful');
const MoodRecordMoodEnum _$moodRecordMoodEnum_excited =
    const MoodRecordMoodEnum._('excited');

MoodRecordMoodEnum _$moodRecordMoodEnumValueOf(String name) {
  switch (name) {
    case 'happy':
      return _$moodRecordMoodEnum_happy;
    case 'calm':
      return _$moodRecordMoodEnum_calm;
    case 'sad':
      return _$moodRecordMoodEnum_sad;
    case 'anxious':
      return _$moodRecordMoodEnum_anxious;
    case 'angry':
      return _$moodRecordMoodEnum_angry;
    case 'tired':
      return _$moodRecordMoodEnum_tired;
    case 'grateful':
      return _$moodRecordMoodEnum_grateful;
    case 'excited':
      return _$moodRecordMoodEnum_excited;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoodRecordMoodEnum> _$moodRecordMoodEnumValues =
    BuiltSet<MoodRecordMoodEnum>(const <MoodRecordMoodEnum>[
  _$moodRecordMoodEnum_happy,
  _$moodRecordMoodEnum_calm,
  _$moodRecordMoodEnum_sad,
  _$moodRecordMoodEnum_anxious,
  _$moodRecordMoodEnum_angry,
  _$moodRecordMoodEnum_tired,
  _$moodRecordMoodEnum_grateful,
  _$moodRecordMoodEnum_excited,
]);

Serializer<MoodRecordMoodEnum> _$moodRecordMoodEnumSerializer =
    _$MoodRecordMoodEnumSerializer();

class _$MoodRecordMoodEnumSerializer
    implements PrimitiveSerializer<MoodRecordMoodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'happy': 'happy',
    'calm': 'calm',
    'sad': 'sad',
    'anxious': 'anxious',
    'angry': 'angry',
    'tired': 'tired',
    'grateful': 'grateful',
    'excited': 'excited',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'happy': 'happy',
    'calm': 'calm',
    'sad': 'sad',
    'anxious': 'anxious',
    'angry': 'angry',
    'tired': 'tired',
    'grateful': 'grateful',
    'excited': 'excited',
  };

  @override
  final Iterable<Type> types = const <Type>[MoodRecordMoodEnum];
  @override
  final String wireName = 'MoodRecordMoodEnum';

  @override
  Object serialize(Serializers serializers, MoodRecordMoodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoodRecordMoodEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoodRecordMoodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoodRecord extends MoodRecord {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final MoodRecordMoodEnum? mood;
  @override
  final int? score;
  @override
  final String? note;
  @override
  final DateTime? recordedAt;

  factory _$MoodRecord([void Function(MoodRecordBuilder)? updates]) =>
      (MoodRecordBuilder()..update(updates))._build();

  _$MoodRecord._(
      {this.id, this.userId, this.mood, this.score, this.note, this.recordedAt})
      : super._();
  @override
  MoodRecord rebuild(void Function(MoodRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoodRecordBuilder toBuilder() => MoodRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoodRecord &&
        id == other.id &&
        userId == other.userId &&
        mood == other.mood &&
        score == other.score &&
        note == other.note &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, mood.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MoodRecord')
          ..add('id', id)
          ..add('userId', userId)
          ..add('mood', mood)
          ..add('score', score)
          ..add('note', note)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class MoodRecordBuilder implements Builder<MoodRecord, MoodRecordBuilder> {
  _$MoodRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  MoodRecordMoodEnum? _mood;
  MoodRecordMoodEnum? get mood => _$this._mood;
  set mood(MoodRecordMoodEnum? mood) => _$this._mood = mood;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  MoodRecordBuilder() {
    MoodRecord._defaults(this);
  }

  MoodRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _mood = $v.mood;
      _score = $v.score;
      _note = $v.note;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MoodRecord other) {
    _$v = other as _$MoodRecord;
  }

  @override
  void update(void Function(MoodRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MoodRecord build() => _build();

  _$MoodRecord _build() {
    final _$result = _$v ??
        _$MoodRecord._(
          id: id,
          userId: userId,
          mood: mood,
          score: score,
          note: note,
          recordedAt: recordedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
