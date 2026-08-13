// @dart=2.19


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_metric.g.dart';

class HealthMetric extends EnumClass {

  @BuiltValueEnumConst(wireName: r'steps')
  static const HealthMetric steps = _$steps;
  @BuiltValueEnumConst(wireName: r'heart_rate')
  static const HealthMetric heartRate = _$heartRate;
  @BuiltValueEnumConst(wireName: r'sleep')
  static const HealthMetric sleep = _$sleep;
  @BuiltValueEnumConst(wireName: r'weight')
  static const HealthMetric weight = _$weight;
  @BuiltValueEnumConst(wireName: r'blood_pressure')
  static const HealthMetric bloodPressure = _$bloodPressure;
  @BuiltValueEnumConst(wireName: r'blood_glucose')
  static const HealthMetric bloodGlucose = _$bloodGlucose;
  @BuiltValueEnumConst(wireName: r'spo2')
  static const HealthMetric spo2 = _$spo2;
  @BuiltValueEnumConst(wireName: r'body_temperature')
  static const HealthMetric bodyTemperature = _$bodyTemperature;

  static Serializer<HealthMetric> get serializer => _$healthMetricSerializer;

  const HealthMetric._(String name): super(name);

  static BuiltSet<HealthMetric> get values => _$values;
  static HealthMetric valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class HealthMetricMixin = Object with _$HealthMetricMixin;

