// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_metric.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const HealthMetric _$steps = const HealthMetric._('steps');
const HealthMetric _$heartRate = const HealthMetric._('heartRate');
const HealthMetric _$sleep = const HealthMetric._('sleep');
const HealthMetric _$weight = const HealthMetric._('weight');
const HealthMetric _$bloodPressure = const HealthMetric._('bloodPressure');
const HealthMetric _$bloodGlucose = const HealthMetric._('bloodGlucose');
const HealthMetric _$spo2 = const HealthMetric._('spo2');
const HealthMetric _$bodyTemperature = const HealthMetric._('bodyTemperature');

HealthMetric _$valueOf(String name) {
  switch (name) {
    case 'steps':
      return _$steps;
    case 'heartRate':
      return _$heartRate;
    case 'sleep':
      return _$sleep;
    case 'weight':
      return _$weight;
    case 'bloodPressure':
      return _$bloodPressure;
    case 'bloodGlucose':
      return _$bloodGlucose;
    case 'spo2':
      return _$spo2;
    case 'bodyTemperature':
      return _$bodyTemperature;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<HealthMetric> _$values =
    BuiltSet<HealthMetric>(const <HealthMetric>[
  _$steps,
  _$heartRate,
  _$sleep,
  _$weight,
  _$bloodPressure,
  _$bloodGlucose,
  _$spo2,
  _$bodyTemperature,
]);

class _$HealthMetricMeta {
  const _$HealthMetricMeta();
  HealthMetric get steps => _$steps;
  HealthMetric get heartRate => _$heartRate;
  HealthMetric get sleep => _$sleep;
  HealthMetric get weight => _$weight;
  HealthMetric get bloodPressure => _$bloodPressure;
  HealthMetric get bloodGlucose => _$bloodGlucose;
  HealthMetric get spo2 => _$spo2;
  HealthMetric get bodyTemperature => _$bodyTemperature;
  HealthMetric valueOf(String name) => _$valueOf(name);
  BuiltSet<HealthMetric> get values => _$values;
}

abstract class _$HealthMetricMixin {
  // ignore: non_constant_identifier_names
  _$HealthMetricMeta get HealthMetric => const _$HealthMetricMeta();
}

Serializer<HealthMetric> _$healthMetricSerializer = _$HealthMetricSerializer();

class _$HealthMetricSerializer implements PrimitiveSerializer<HealthMetric> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'steps': 'steps',
    'heartRate': 'heart_rate',
    'sleep': 'sleep',
    'weight': 'weight',
    'bloodPressure': 'blood_pressure',
    'bloodGlucose': 'blood_glucose',
    'spo2': 'spo2',
    'bodyTemperature': 'body_temperature',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'steps': 'steps',
    'heart_rate': 'heartRate',
    'sleep': 'sleep',
    'weight': 'weight',
    'blood_pressure': 'bloodPressure',
    'blood_glucose': 'bloodGlucose',
    'spo2': 'spo2',
    'body_temperature': 'bodyTemperature',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthMetric];
  @override
  final String wireName = 'HealthMetric';

  @override
  Object serialize(Serializers serializers, HealthMetric object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthMetric deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthMetric.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
