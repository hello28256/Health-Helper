// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';

// tests for HealthRecord
void main() {
  final instance = HealthRecordBuilder();
  // TODO add properties to the builder and call build()

  group(HealthRecord, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String userId
    test('to test the property `userId`', () async {
      // TODO
    });

    // HealthMetric metric
    test('to test the property `metric`', () async {
      // TODO
    });

    // Decimal 12,4 — 取决于 metric 含义
    // num value
    test('to test the property `value`', () async {
      // TODO
    });

    // String unit
    test('to test the property `unit`', () async {
      // TODO
    });

    // DateTime startAt
    test('to test the property `startAt`', () async {
      // TODO
    });

    // 可选：区间测量（睡眠 / 血压）
    // DateTime endAt
    test('to test the property `endAt`', () async {
      // TODO
    });

    // String source_
    test('to test the property `source_`', () async {
      // TODO
    });

    // 原始 payload（高血压含 systolic/diastolic）
    // BuiltMap<String, JsonObject> raw
    test('to test the property `raw`', () async {
      // TODO
    });

    // DateTime createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

  });
}
