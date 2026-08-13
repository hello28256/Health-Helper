// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_nutrition_summary_by_meal_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyNutritionSummaryByMealValue
    extends DailyNutritionSummaryByMealValue {
  @override
  final num? kcal;
  @override
  final int? recordCount;

  factory _$DailyNutritionSummaryByMealValue(
          [void Function(DailyNutritionSummaryByMealValueBuilder)? updates]) =>
      (DailyNutritionSummaryByMealValueBuilder()..update(updates))._build();

  _$DailyNutritionSummaryByMealValue._({this.kcal, this.recordCount})
      : super._();
  @override
  DailyNutritionSummaryByMealValue rebuild(
          void Function(DailyNutritionSummaryByMealValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyNutritionSummaryByMealValueBuilder toBuilder() =>
      DailyNutritionSummaryByMealValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyNutritionSummaryByMealValue &&
        kcal == other.kcal &&
        recordCount == other.recordCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kcal.hashCode);
    _$hash = $jc(_$hash, recordCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DailyNutritionSummaryByMealValue')
          ..add('kcal', kcal)
          ..add('recordCount', recordCount))
        .toString();
  }
}

class DailyNutritionSummaryByMealValueBuilder
    implements
        Builder<DailyNutritionSummaryByMealValue,
            DailyNutritionSummaryByMealValueBuilder> {
  _$DailyNutritionSummaryByMealValue? _$v;

  num? _kcal;
  num? get kcal => _$this._kcal;
  set kcal(num? kcal) => _$this._kcal = kcal;

  int? _recordCount;
  int? get recordCount => _$this._recordCount;
  set recordCount(int? recordCount) => _$this._recordCount = recordCount;

  DailyNutritionSummaryByMealValueBuilder() {
    DailyNutritionSummaryByMealValue._defaults(this);
  }

  DailyNutritionSummaryByMealValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kcal = $v.kcal;
      _recordCount = $v.recordCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyNutritionSummaryByMealValue other) {
    _$v = other as _$DailyNutritionSummaryByMealValue;
  }

  @override
  void update(void Function(DailyNutritionSummaryByMealValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyNutritionSummaryByMealValue build() => _build();

  _$DailyNutritionSummaryByMealValue _build() {
    final _$result = _$v ??
        _$DailyNutritionSummaryByMealValue._(
          kcal: kcal,
          recordCount: recordCount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
