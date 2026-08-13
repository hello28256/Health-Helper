// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciseRecord extends ExerciseRecord {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final String? typeId;
  @override
  final DateTime? startedAt;
  @override
  final int? durationSec;
  @override
  final num? distanceKm;
  @override
  final num? calories;
  @override
  final DateTime? createdAt;

  factory _$ExerciseRecord([void Function(ExerciseRecordBuilder)? updates]) =>
      (ExerciseRecordBuilder()..update(updates))._build();

  _$ExerciseRecord._(
      {this.id,
      this.userId,
      this.typeId,
      this.startedAt,
      this.durationSec,
      this.distanceKm,
      this.calories,
      this.createdAt})
      : super._();
  @override
  ExerciseRecord rebuild(void Function(ExerciseRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciseRecordBuilder toBuilder() => ExerciseRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciseRecord &&
        id == other.id &&
        userId == other.userId &&
        typeId == other.typeId &&
        startedAt == other.startedAt &&
        durationSec == other.durationSec &&
        distanceKm == other.distanceKm &&
        calories == other.calories &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, typeId.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, durationSec.hashCode);
    _$hash = $jc(_$hash, distanceKm.hashCode);
    _$hash = $jc(_$hash, calories.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExerciseRecord')
          ..add('id', id)
          ..add('userId', userId)
          ..add('typeId', typeId)
          ..add('startedAt', startedAt)
          ..add('durationSec', durationSec)
          ..add('distanceKm', distanceKm)
          ..add('calories', calories)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ExerciseRecordBuilder
    implements Builder<ExerciseRecord, ExerciseRecordBuilder> {
  _$ExerciseRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _typeId;
  String? get typeId => _$this._typeId;
  set typeId(String? typeId) => _$this._typeId = typeId;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  int? _durationSec;
  int? get durationSec => _$this._durationSec;
  set durationSec(int? durationSec) => _$this._durationSec = durationSec;

  num? _distanceKm;
  num? get distanceKm => _$this._distanceKm;
  set distanceKm(num? distanceKm) => _$this._distanceKm = distanceKm;

  num? _calories;
  num? get calories => _$this._calories;
  set calories(num? calories) => _$this._calories = calories;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ExerciseRecordBuilder() {
    ExerciseRecord._defaults(this);
  }

  ExerciseRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _typeId = $v.typeId;
      _startedAt = $v.startedAt;
      _durationSec = $v.durationSec;
      _distanceKm = $v.distanceKm;
      _calories = $v.calories;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciseRecord other) {
    _$v = other as _$ExerciseRecord;
  }

  @override
  void update(void Function(ExerciseRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciseRecord build() => _build();

  _$ExerciseRecord _build() {
    final _$result = _$v ??
        _$ExerciseRecord._(
          id: id,
          userId: userId,
          typeId: typeId,
          startedAt: startedAt,
          durationSec: durationSec,
          distanceKm: distanceKm,
          calories: calories,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
