# health_helper_api.api.UsersApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiUsersMeGet**](UsersApi.md#apiusersmeget) | **GET** /api/users/me | 获取当前用户资料
[**apiUsersMePatch**](UsersApi.md#apiusersmepatch) | **PATCH** /api/users/me | 更新用户资料


# **apiUsersMeGet**
> PublicUser apiUsersMeGet()

获取当前用户资料

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getUsersApi();

try {
    final response = api.apiUsersMeGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiUsersMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PublicUser**](PublicUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiUsersMePatch**
> PublicUser apiUsersMePatch(apiUsersMePatchRequest)

更新用户资料

部分更新 —— 体重 weightKg 用于卡路里计算

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getUsersApi();
final ApiUsersMePatchRequest apiUsersMePatchRequest = ; // ApiUsersMePatchRequest | 

try {
    final response = api.apiUsersMePatch(apiUsersMePatchRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UsersApi->apiUsersMePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiUsersMePatchRequest** | [**ApiUsersMePatchRequest**](ApiUsersMePatchRequest.md)|  | 

### Return type

[**PublicUser**](PublicUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

