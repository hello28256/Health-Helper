// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_record_consumed.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietRecordConsumed extends DietRecordConsumed {
  @override
  final num? kcal;
  @override
  final num? proteinG;
  @override
  final num? fatG;
  @override
  final num? carbsG;
  @override
  final num? fiberG;
  @override
  final num? sodiumMg;

  factory _$DietRecordConsumed(
          [void Function(DietRecordConsumedBuilder)? updates]) =>
      (DietRecordConsumedBuilder()..update(updates))._build();

  _$DietRecordConsumed._(
      {this.kcal,
      this.proteinG,
      this.fatG,
      this.carbsG,
      this.fiberG,
      this.sodiumMg})
      : super._();
  @override
  DietRecordConsumed rebuild(
          void Function(DietRecordConsumedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietRecordConsumedBuilder toBuilder() =>
      DietRecordConsumedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietRecordConsumed &&
        kcal == other.kcal &&
        proteinG == other.proteinG &&
        fatG == other.fatG &&
        carbsG == other.carbsG &&
        fiberG == other.fiberG &&
        sodiumMg == other.sodiumMg;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kcal.hashCode);
    _$hash = $jc(_$hash, proteinG.hashCode);
    _$hash = $jc(_$hash, fatG.hashCode);
    _$hash = $jc(_$hash, carbsG.hashCode);
    _$hash = $jc(_$hash, fiberG.hashCode);
    _$hash = $jc(_$hash, sodiumMg.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietRecordConsumed')
          ..add('kcal', kcal)
          ..add('proteinG', proteinG)
          ..add('fatG', fatG)
          ..add('carbsG', carbsG)
          ..add('fiberG', fiberG)
          ..add('sodiumMg', sodiumMg))
        .toString();
  }
}

class DietRecordConsumedBuilder
    implements Builder<DietRecordConsumed, DietRecordConsumedBuilder> {
  _$DietRecordConsumed? _$v;

  num? _kcal;
  num? get kcal => _$this._kcal;
  set kcal(num? kcal) => _$this._kcal = kcal;

  num? _proteinG;
  num? get proteinG => _$this._proteinG;
  set proteinG(num? proteinG) => _$this._proteinG = proteinG;

  num? _fatG;
  num? get fatG => _$this._fatG;
  set fatG(num? fatG) => _$this._fatG = fatG;

  num? _carbsG;
  num? get carbsG => _$this._carbsG;
  set carbsG(num? carbsG) => _$this._carbsG = carbsG;

  num? _fiberG;
  num? get fiberG => _$this._fiberG;
  set fiberG(num? fiberG) => _$this._fiberG = fiberG;

  num? _sodiumMg;
  num? get sodiumMg => _$this._sodiumMg;
  set sodiumMg(num? sodiumMg) => _$this._sodiumMg = sodiumMg;

  DietRecordConsumedBuilder() {
    DietRecordConsumed._defaults(this);
  }

  DietRecordConsumedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kcal = $v.kcal;
      _proteinG = $v.proteinG;
      _fatG = $v.fatG;
      _carbsG = $v.carbsG;
      _fiberG = $v.fiberG;
      _sodiumMg = $v.sodiumMg;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietRecordConsumed other) {
    _$v = other as _$DietRecordConsumed;
  }

  @override
  void update(void Function(DietRecordConsumedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietRecordConsumed build() => _build();

  _$DietRecordConsumed _build() {
    final _$result = _$v ??
        _$DietRecordConsumed._(
          kcal: kcal,
          proteinG: proteinG,
          fatG: fatG,
          carbsG: carbsG,
          fiberG: fiberG,
          sodiumMg: sodiumMg,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
