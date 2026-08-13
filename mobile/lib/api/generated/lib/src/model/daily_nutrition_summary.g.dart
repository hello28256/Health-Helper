// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_nutrition_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyNutritionSummary extends DailyNutritionSummary {
  @override
  final String? date;
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
  @override
  final int? recordCount;
  @override
  final BuiltMap<String, DailyNutritionSummaryByMealValue>? byMeal;

  factory _$DailyNutritionSummary(
          [void Function(DailyNutritionSummaryBuilder)? updates]) =>
      (DailyNutritionSummaryBuilder()..update(updates))._build();

  _$DailyNutritionSummary._(
      {this.date,
      this.kcal,
      this.proteinG,
      this.fatG,
      this.carbsG,
      this.fiberG,
      this.sodiumMg,
      this.recordCount,
      this.byMeal})
      : super._();
  @override
  DailyNutritionSummary rebuild(
          void Function(DailyNutritionSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyNutritionSummaryBuilder toBuilder() =>
      DailyNutritionSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyNutritionSummary &&
        date == other.date &&
        kcal == other.kcal &&
        proteinG == other.proteinG &&
        fatG == other.fatG &&
        carbsG == other.carbsG &&
        fiberG == other.fiberG &&
        sodiumMg == other.sodiumMg &&
        recordCount == other.recordCount &&
        byMeal == other.byMeal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, kcal.hashCode);
    _$hash = $jc(_$hash, proteinG.hashCode);
    _$hash = $jc(_$hash, fatG.hashCode);
    _$hash = $jc(_$hash, carbsG.hashCode);
    _$hash = $jc(_$hash, fiberG.hashCode);
    _$hash = $jc(_$hash, sodiumMg.hashCode);
    _$hash = $jc(_$hash, recordCount.hashCode);
    _$hash = $jc(_$hash, byMeal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DailyNutritionSummary')
          ..add('date', date)
          ..add('kcal', kcal)
          ..add('proteinG', proteinG)
          ..add('fatG', fatG)
          ..add('carbsG', carbsG)
          ..add('fiberG', fiberG)
          ..add('sodiumMg', sodiumMg)
          ..add('recordCount', recordCount)
          ..add('byMeal', byMeal))
        .toString();
  }
}

class DailyNutritionSummaryBuilder
    implements Builder<DailyNutritionSummary, DailyNutritionSummaryBuilder> {
  _$DailyNutritionSummary? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

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

  int? _recordCount;
  int? get recordCount => _$this._recordCount;
  set recordCount(int? recordCount) => _$this._recordCount = recordCount;

  MapBuilder<String, DailyNutritionSummaryByMealValue>? _byMeal;
  MapBuilder<String, DailyNutritionSummaryByMealValue> get byMeal =>
      _$this._byMeal ??= MapBuilder<String, DailyNutritionSummaryByMealValue>();
  set byMeal(MapBuilder<String, DailyNutritionSummaryByMealValue>? byMeal) =>
      _$this._byMeal = byMeal;

  DailyNutritionSummaryBuilder() {
    DailyNutritionSummary._defaults(this);
  }

  DailyNutritionSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _kcal = $v.kcal;
      _proteinG = $v.proteinG;
      _fatG = $v.fatG;
      _carbsG = $v.carbsG;
      _fiberG = $v.fiberG;
      _sodiumMg = $v.sodiumMg;
      _recordCount = $v.recordCount;
      _byMeal = $v.byMeal?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyNutritionSummary other) {
    _$v = other as _$DailyNutritionSummary;
  }

  @override
  void update(void Function(DailyNutritionSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyNutritionSummary build() => _build();

  _$DailyNutritionSummary _build() {
    _$DailyNutritionSummary _$result;
    try {
      _$result = _$v ??
          _$DailyNutritionSummary._(
            date: date,
            kcal: kcal,
            proteinG: proteinG,
            fatG: fatG,
            carbsG: carbsG,
            fiberG: fiberG,
            sodiumMg: sodiumMg,
            recordCount: recordCount,
            byMeal: _byMeal?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byMeal';
        _byMeal?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyNutritionSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
