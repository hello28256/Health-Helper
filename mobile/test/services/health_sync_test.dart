// HealthSync + HealthPlatform 测试
// 覆盖：
// 1. HealthSync 上报步数（走 upsertSteps）
// 2. HealthSync 上报心率（走 uploadOne + recordBatch）
// 3. 权限拒绝 → 返回 permissionDenied=true，不调上传
// 4. 上传抛错 → 返回 error，不中断
// 5. NoOpHealthPlatform 在 web 环境返回空

import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/providers/health_provider.dart' show HealthRecordInput;
import 'package:health_helper/services/health_platform.dart';
import 'package:health_helper/services/health_sync.dart';
import 'package:health_helper_api/health_helper_api.dart';

class _FakeHealthPlatform implements HealthPlatform {
  _FakeHealthPlatform({
    this.granted = true,
    this.points = const [],
    this.throwOnRead,
  });
  bool granted;
  List<HealthDataPoint> points;
  Exception? throwOnRead;
  bool requestCalled = false;
  int readCalls = 0;

  @override
  Future<bool> requestAuthorization() async {
    requestCalled = true;
    return granted;
  }

  @override
  Future<List<HealthDataPoint>> readRange({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  }) async {
    readCalls++;
    if (throwOnRead != null) throw throwOnRead!;
    return points;
  }

  @override
  String get platformName => 'fake';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('NoOpHealthPlatform 默认空数据', () async {
    final p = NoOpHealthPlatform();
    expect(await p.requestAuthorization(), false);
    expect(await p.readRange(
      metric: HealthMetric.steps,
      start: DateTime(2026, 1, 1),
      end: DateTime(2026, 1, 2),
    ), isEmpty);
    expect(p.platformName, 'unsupported');
  });

  test('HealthSync 上报步数走 upsertSteps', () async {
    final platform = _FakeHealthPlatform(
      points: [
        HealthDataPoint(
          metric: HealthMetric.steps,
          value: 8500,
          unit: 'count',
          startAt: DateTime(2026, 8, 13, 8),
          endAt: DateTime(2026, 8, 13, 20),
          source: 'ios_healthkit',
        ),
      ],
    );
    var uploadedSteps = 0;
    var uploadedHealth = 0;
    final sync = HealthSync(
      platform: platform,
      uploadOne: (_) async => uploadedHealth++,
      upsertSteps: (s, _) async => uploadedSteps = s,
    );
    final result = await sync.syncMetric(metric: HealthMetric.steps);
    expect(result.uploaded, 1);
    expect(result.permissionDenied, false);
    expect(uploadedSteps, 8500);
    expect(uploadedHealth, 0);
  });

  test('HealthSync 上报心率走 uploadOne', () async {
    final platform = _FakeHealthPlatform(
      points: [
        HealthDataPoint(
          metric: HealthMetric.heartRate,
          value: 72,
          unit: 'bpm',
          startAt: DateTime(2026, 8, 13, 10),
          source: 'ios_healthkit',
        ),
      ],
    );
    HealthRecordInput? captured;
    var uploadedSteps = 0;
    final sync = HealthSync(
      platform: platform,
      uploadOne: (input) async => captured = input,
      upsertSteps: (_, _) async => uploadedSteps++,
    );
    final result = await sync.syncMetric(metric: HealthMetric.heartRate);
    expect(result.uploaded, 1);
    expect(captured, isNotNull);
    expect(captured!.metric, HealthMetric.heartRate);
    expect(captured!.value, 72);
    expect(captured!.source, 'ios_healthkit');
    expect(uploadedSteps, 0);
  });

  test('权限拒绝 → 不调 upload', () async {
    final platform = _FakeHealthPlatform(granted: false);
    var called = 0;
    final sync = HealthSync(
      platform: platform,
      uploadOne: (_) async => called++,
      upsertSteps: (_, _) async => called++,
    );
    final result = await sync.syncMetric(metric: HealthMetric.heartRate);
    expect(result.permissionDenied, true);
    expect(result.uploaded, 0);
    expect(called, 0);
    expect(platform.readCalls, 0);
  });

  test('上传抛错 → 返回 error 包含已上传数', () async {
    final platform = _FakeHealthPlatform(
      points: List.generate(
        3,
        (i) => HealthDataPoint(
          metric: HealthMetric.heartRate,
          value: 70 + i,
          unit: 'bpm',
          startAt: DateTime(2026, 8, 13, 10, i),
          source: 'ios_healthkit',
        ),
      ),
    );
    var invocations = 0;
    final sync = HealthSync(
      platform: platform,
      uploadOne: (_) async {
        invocations++;
        if (invocations == 2) throw Exception('upload failed');
      },
      upsertSteps: (_, _) async {},
    );
    final result = await sync.syncMetric(metric: HealthMetric.heartRate);
    expect(result.uploaded, 1); // 第一个成功
    expect(result.error, contains('upload failed'));
  });

  test('readRange 抛错 → 上报 0 + error', () async {
    final platform = _FakeHealthPlatform(throwOnRead: Exception('platform fail'));
    final sync = HealthSync(
      platform: platform,
      uploadOne: (_) async {},
      upsertSteps: (_, _) async {},
    );
    final result = await sync.syncMetric(metric: HealthMetric.heartRate);
    expect(result.uploaded, 0);
    expect(result.error, contains('platform fail'));
  });
}