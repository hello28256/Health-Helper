# health_helper_api.api.DevicesApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiDevicesDeviceIdDelete**](DevicesApi.md#apidevicesdeviceiddelete) | **DELETE** /api/devices/{deviceId} | 撤销某 device 的所有 token
[**apiDevicesPost**](DevicesApi.md#apidevicespost) | **POST** /api/devices | 注册/更新推送 token


# **apiDevicesDeviceIdDelete**
> apiDevicesDeviceIdDelete(deviceId)

撤销某 device 的所有 token

幂等：找不到时也返回 204，mobile 端 token rotation 时反复调用不报错

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getDevicesApi();
final String deviceId = deviceId_example; // String | 

try {
    api.apiDevicesDeviceIdDelete(deviceId);
} catch on DioException (e) {
    print('Exception when calling DevicesApi->apiDevicesDeviceIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiDevicesPost**
> DeviceToken apiDevicesPost(apiDevicesPostRequest)

注册/更新推送 token

幂等 upsert：key = (userId, deviceId, platform)。APNs / FCM 换 token 时再调一次即可覆盖。fcmToken 和 apnsToken 至少要传一个。

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getDevicesApi();
final ApiDevicesPostRequest apiDevicesPostRequest = ; // ApiDevicesPostRequest | 

try {
    final response = api.apiDevicesPost(apiDevicesPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DevicesApi->apiDevicesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiDevicesPostRequest** | [**ApiDevicesPostRequest**](ApiDevicesPostRequest.md)|  | 

### Return type

[**DeviceToken**](DeviceToken.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

