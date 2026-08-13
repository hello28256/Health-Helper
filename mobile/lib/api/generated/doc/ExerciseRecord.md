# health_helper_api.model.ExerciseRecord

## Load the model package
```dart
import 'package:health_helper_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**userId** | **String** |  | [optional] 
**typeId** | **String** |  | [optional] 
**startedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**durationSec** | **int** |  | [optional] 
**distanceKm** | **num** |  | [optional] 
**calories** | **num** | 服务端按 MET × weightKg × duration 计算 | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


