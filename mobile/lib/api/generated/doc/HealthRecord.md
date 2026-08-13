# health_helper_api.model.HealthRecord

## Load the model package
```dart
import 'package:health_helper_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**userId** | **String** |  | [optional] 
**metric** | [**HealthMetric**](HealthMetric.md) |  | [optional] 
**value** | **num** | Decimal 12,4 — 取决于 metric 含义 | [optional] 
**unit** | **String** |  | [optional] 
**startAt** | [**DateTime**](DateTime.md) |  | [optional] 
**endAt** | [**DateTime**](DateTime.md) | 可选：区间测量（睡眠 / 血压） | [optional] 
**source_** | **String** |  | [optional] 
**raw** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | 原始 payload（高血压含 systolic/diastolic） | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


