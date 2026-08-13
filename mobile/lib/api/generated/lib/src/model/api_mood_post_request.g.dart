// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_mood_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_happy =
    const ApiMoodPostRequestMoodEnum._('happy');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_calm =
    const ApiMoodPostRequestMoodEnum._('calm');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_sad =
    const ApiMoodPostRequestMoodEnum._('sad');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_anxious =
    const ApiMoodPostRequestMoodEnum._('anxious');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_angry =
    const ApiMoodPostRequestMoodEnum._('angry');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_tired =
    const ApiMoodPostRequestMoodEnum._('tired');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_grateful =
    const ApiMoodPostRequestMoodEnum._('grateful');
const ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnum_excited =
    const ApiMoodPostRequestMoodEnum._('excited');

ApiMoodPostRequestMoodEnum _$apiMoodPostRequestMoodEnumValueOf(String name) {
  switch (name) {
    case 'happy':
      return _$apiMoodPostRequestMoodEnum_happy;
    case 'calm':
      return _$apiMoodPostRequestMoodEnum_calm;
    case 'sad':
      return _$apiMoodPostRequestMoodEnum_sad;
    case 'anxious':
      return _$apiMoodPostRequestMoodEnum_anxious;
    case 'angry':
      return _$apiMoodPostRequestMoodEnum_angry;
    case 'tired':
      return _$apiMoodPostRequestMoodEnum_tired;
    case 'grateful':
      return _$apiMoodPostRequestMoodEnum_grateful;
    case 'excited':
      return _$apiMoodPostRequestMoodEnum_excited;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiMoodPostRequestMoodEnum> _$apiMoodPostRequestMoodEnumValues =
    BuiltSet<ApiMoodPostRequestMoodEnum>(const <ApiMoodPostRequestMoodEnum>[
  _$apiMoodPostRequestMoodEnum_happy,
  _$apiMoodPostRequestMoodEnum_calm,
  _$apiMoodPostRequestMoodEnum_sad,
  _$apiMoodPostRequestMoodEnum_anxious,
  _$apiMoodPostRequestMoodEnum_angry,
  _$apiMoodPostRequestMoodEnum_tired,
  _$apiMoodPostRequestMoodEnum_grateful,
  _$apiMoodPostRequestMoodEnum_excited,
]);

Serializer<ApiMoodPostRequestMoodEnum> _$apiMoodPostRequestMoodEnumSerializer =
    _$ApiMoodPostRequestMoodEnumSerializer();

class _$ApiMoodPostRequestMoodEnumSerializer
    implements PrimitiveSerializer<ApiMoodPostRequestMoodEnum> {
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
  final Iterable<Type> types = const <Type>[ApiMoodPostRequestMoodEnum];
  @override
  final String wireName = 'ApiMoodPostRequestMoodEnum';

  @override
  Object serialize(Serializers serializers, ApiMoodPostRequestMoodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiMoodPostRequestMoodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiMoodPostRequestMoodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiMoodPostRequest extends ApiMoodPostRequest {
  @override
  final ApiMoodPostRequestMoodEnum mood;
  @override
  final int? score;
  @override
  final String? note;
  @override
  final DateTime? recordedAt;

  factory _$ApiMoodPostRequest(
          [void Function(ApiMoodPostRequestBuilder)? updates]) =>
      (ApiMoodPostRequestBuilder()..update(updates))._build();

  _$ApiMoodPostRequest._(
      {required this.mood, this.score, this.note, this.recordedAt})
      : super._();
  @override
  ApiMoodPostRequest rebuild(
          void Function(ApiMoodPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiMoodPostRequestBuilder toBuilder() =>
      ApiMoodPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiMoodPostRequest &&
        mood == other.mood &&
        score == other.score &&
        note == other.note &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mood.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiMoodPostRequest')
          ..add('mood', mood)
          ..add('score', score)
          ..add('note', note)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class ApiMoodPostRequestBuilder
    implements Builder<ApiMoodPostRequest, ApiMoodPostRequestBuilder> {
  _$ApiMoodPostRequest? _$v;

  ApiMoodPostRequestMoodEnum? _mood;
  ApiMoodPostRequestMoodEnum? get mood => _$this._mood;
  set mood(ApiMoodPostRequestMoodEnum? mood) => _$this._mood = mood;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  ApiMoodPostRequestBuilder() {
    ApiMoodPostRequest._defaults(this);
  }

  ApiMoodPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mood = $v.mood;
      _score = $v.score;
      _note = $v.note;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiMoodPostRequest other) {
    _$v = other as _$ApiMoodPostRequest;
  }

  @override
  void update(void Function(ApiMoodPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiMoodPostRequest build() => _build();

  _$ApiMoodPostRequest _build() {
    final _$result = _$v ??
        _$ApiMoodPostRequest._(
          mood: BuiltValueNullFieldError.checkNotNull(
              mood, r'ApiMoodPostRequest', 'mood'),
          score: score,
          note: note,
          recordedAt: recordedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
