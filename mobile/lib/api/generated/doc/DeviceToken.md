# health_helper_api.model.DeviceToken

## Load the model package
```dart
import 'package:health_helper_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**userId** | **String** |  | [optional] 
**deviceId** | **String** |  | [optional] 
**platform** | [**DevicePlatform**](DevicePlatform.md) |  | [optional] 
**fcmToken** | **String** | Android / Web 推送 | [optional] 
**apnsToken** | **String** | iOS 推送 | [optional] 
**appVersion** | **String** |  | [optional] 
**locale** | **String** |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | [optional] 
**lastSeenAt** | [**DateTime**](DateTime.md) |  | [optional] 
**revokedAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


