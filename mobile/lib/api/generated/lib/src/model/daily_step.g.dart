// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DailyStepSource_Enum _$dailyStepSourceEnum_iosPedometer =
    const DailyStepSource_Enum._('iosPedometer');
const DailyStepSource_Enum _$dailyStepSourceEnum_androidSensor =
    const DailyStepSource_Enum._('androidSensor');
const DailyStepSource_Enum _$dailyStepSourceEnum_manual =
    const DailyStepSource_Enum._('manual');

DailyStepSource_Enum _$dailyStepSourceEnumValueOf(String name) {
  switch (name) {
    case 'iosPedometer':
      return _$dailyStepSourceEnum_iosPedometer;
    case 'androidSensor':
      return _$dailyStepSourceEnum_androidSensor;
    case 'manual':
      return _$dailyStepSourceEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DailyStepSource_Enum> _$dailyStepSourceEnumValues =
    BuiltSet<DailyStepSource_Enum>(const <DailyStepSource_Enum>[
  _$dailyStepSourceEnum_iosPedometer,
  _$dailyStepSourceEnum_androidSensor,
  _$dailyStepSourceEnum_manual,
]);

Serializer<DailyStepSource_Enum> _$dailyStepSourceEnumSerializer =
    _$DailyStepSource_EnumSerializer();

class _$DailyStepSource_EnumSerializer
    implements PrimitiveSerializer<DailyStepSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'iosPedometer': 'ios_pedometer',
    'androidSensor': 'android_sensor',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ios_pedometer': 'iosPedometer',
    'android_sensor': 'androidSensor',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[DailyStepSource_Enum];
  @override
  final String wireName = 'DailyStepSource_Enum';

  @override
  Object serialize(Serializers serializers, DailyStepSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DailyStepSource_Enum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DailyStepSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DailyStep extends DailyStep {
  @override
  final String? userId;
  @override
  final String? date;
  @override
  final int? steps;
  @override
  final DailyStepSource_Enum? source_;
  @override
  final DateTime? updatedAt;

  factory _$DailyStep([void Function(DailyStepBuilder)? updates]) =>
      (DailyStepBuilder()..update(updates))._build();

  _$DailyStep._(
      {this.userId, this.date, this.steps, this.source_, this.updatedAt})
      : super._();
  @override
  DailyStep rebuild(void Function(DailyStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyStepBuilder toBuilder() => DailyStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyStep &&
        userId == other.userId &&
        date == other.date &&
        steps == other.steps &&
        source_ == other.source_ &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DailyStep')
          ..add('userId', userId)
          ..add('date', date)
          ..add('steps', steps)
          ..add('source_', source_)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class DailyStepBuilder implements Builder<DailyStep, DailyStepBuilder> {
  _$DailyStep? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  int? _steps;
  int? get steps => _$this._steps;
  set steps(int? steps) => _$this._steps = steps;

  DailyStepSource_Enum? _source_;
  DailyStepSource_Enum? get source_ => _$this._source_;
  set source_(DailyStepSource_Enum? source_) => _$this._source_ = source_;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DailyStepBuilder() {
    DailyStep._defaults(this);
  }

  DailyStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _date = $v.date;
      _steps = $v.steps;
      _source_ = $v.source_;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyStep other) {
    _$v = other as _$DailyStep;
  }

  @override
  void update(void Function(DailyStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyStep build() => _build();

  _$DailyStep _build() {
    final _$result = _$v ??
        _$DailyStep._(
          userId: userId,
          date: date,
          steps: steps,
          source_: source_,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
