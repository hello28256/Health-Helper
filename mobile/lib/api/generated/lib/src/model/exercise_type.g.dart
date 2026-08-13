// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciseType extends ExerciseType {
  @override
  final String? id;
  @override
  final String? displayNameZh;
  @override
  final String? displayNameEn;
  @override
  final num? met;
  @override
  final String? notes;

  factory _$ExerciseType([void Function(ExerciseTypeBuilder)? updates]) =>
      (ExerciseTypeBuilder()..update(updates))._build();

  _$ExerciseType._(
      {this.id, this.displayNameZh, this.displayNameEn, this.met, this.notes})
      : super._();
  @override
  ExerciseType rebuild(void Function(ExerciseTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciseTypeBuilder toBuilder() => ExerciseTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciseType &&
        id == other.id &&
        displayNameZh == other.displayNameZh &&
        displayNameEn == other.displayNameEn &&
        met == other.met &&
        notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayNameZh.hashCode);
    _$hash = $jc(_$hash, displayNameEn.hashCode);
    _$hash = $jc(_$hash, met.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExerciseType')
          ..add('id', id)
          ..add('displayNameZh', displayNameZh)
          ..add('displayNameEn', displayNameEn)
          ..add('met', met)
          ..add('notes', notes))
        .toString();
  }
}

class ExerciseTypeBuilder
    implements Builder<ExerciseType, ExerciseTypeBuilder> {
  _$ExerciseType? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayNameZh;
  String? get displayNameZh => _$this._displayNameZh;
  set displayNameZh(String? displayNameZh) =>
      _$this._displayNameZh = displayNameZh;

  String? _displayNameEn;
  String? get displayNameEn => _$this._displayNameEn;
  set displayNameEn(String? displayNameEn) =>
      _$this._displayNameEn = displayNameEn;

  num? _met;
  num? get met => _$this._met;
  set met(num? met) => _$this._met = met;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  ExerciseTypeBuilder() {
    ExerciseType._defaults(this);
  }

  ExerciseTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayNameZh = $v.displayNameZh;
      _displayNameEn = $v.displayNameEn;
      _met = $v.met;
      _notes = $v.notes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciseType other) {
    _$v = other as _$ExerciseType;
  }

  @override
  void update(void Function(ExerciseTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciseType build() => _build();

  _$ExerciseType _build() {
    final _$result = _$v ??
        _$ExerciseType._(
          id: id,
          displayNameZh: displayNameZh,
          displayNameEn: displayNameEn,
          met: met,
          notes: notes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
