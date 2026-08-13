// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_trend_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MoodTrendPoint extends MoodTrendPoint {
  @override
  final String? date;
  @override
  final num? avgScore;
  @override
  final int? recordCount;
  @override
  final String? dominantMood;

  factory _$MoodTrendPoint([void Function(MoodTrendPointBuilder)? updates]) =>
      (MoodTrendPointBuilder()..update(updates))._build();

  _$MoodTrendPoint._(
      {this.date, this.avgScore, this.recordCount, this.dominantMood})
      : super._();
  @override
  MoodTrendPoint rebuild(void Function(MoodTrendPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoodTrendPointBuilder toBuilder() => MoodTrendPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoodTrendPoint &&
        date == other.date &&
        avgScore == other.avgScore &&
        recordCount == other.recordCount &&
        dominantMood == other.dominantMood;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, avgScore.hashCode);
    _$hash = $jc(_$hash, recordCount.hashCode);
    _$hash = $jc(_$hash, dominantMood.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MoodTrendPoint')
          ..add('date', date)
          ..add('avgScore', avgScore)
          ..add('recordCount', recordCount)
          ..add('dominantMood', dominantMood))
        .toString();
  }
}

class MoodTrendPointBuilder
    implements Builder<MoodTrendPoint, MoodTrendPointBuilder> {
  _$MoodTrendPoint? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  num? _avgScore;
  num? get avgScore => _$this._avgScore;
  set avgScore(num? avgScore) => _$this._avgScore = avgScore;

  int? _recordCount;
  int? get recordCount => _$this._recordCount;
  set recordCount(int? recordCount) => _$this._recordCount = recordCount;

  String? _dominantMood;
  String? get dominantMood => _$this._dominantMood;
  set dominantMood(String? dominantMood) => _$this._dominantMood = dominantMood;

  MoodTrendPointBuilder() {
    MoodTrendPoint._defaults(this);
  }

  MoodTrendPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _avgScore = $v.avgScore;
      _recordCount = $v.recordCount;
      _dominantMood = $v.dominantMood;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MoodTrendPoint other) {
    _$v = other as _$MoodTrendPoint;
  }

  @override
  void update(void Function(MoodTrendPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MoodTrendPoint build() => _build();

  _$MoodTrendPoint _build() {
    final _$result = _$v ??
        _$MoodTrendPoint._(
          date: date,
          avgScore: avgScore,
          recordCount: recordCount,
          dominantMood: dominantMood,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
