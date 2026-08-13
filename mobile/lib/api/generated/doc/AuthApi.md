# health_helper_api.api.AuthApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiAuthLoginPost**](AuthApi.md#apiauthloginpost) | **POST** /api/auth/login | 登录
[**apiAuthLogoutPost**](AuthApi.md#apiauthlogoutpost) | **POST** /api/auth/logout | 登出（撤销当前端 refresh token）
[**apiAuthRefreshPost**](AuthApi.md#apiauthrefreshpost) | **POST** /api/auth/refresh | 刷新 access token
[**apiAuthRegisterPost**](AuthApi.md#apiauthregisterpost) | **POST** /api/auth/register | 注册新账号


# **apiAuthLoginPost**
> AuthResult apiAuthLoginPost(apiAuthLoginPostRequest)

登录

同端重复登录会撤销旧 refresh token 并签发新的（rotation）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getAuthApi();
final ApiAuthLoginPostRequest apiAuthLoginPostRequest = ; // ApiAuthLoginPostRequest | 

try {
    final response = api.apiAuthLoginPost(apiAuthLoginPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->apiAuthLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiAuthLoginPostRequest** | [**ApiAuthLoginPostRequest**](ApiAuthLoginPostRequest.md)|  | 

### Return type

[**AuthResult**](AuthResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiAuthLogoutPost**
> apiAuthLogoutPost(apiAuthRefreshPostRequest)

登出（撤销当前端 refresh token）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getAuthApi();
final ApiAuthRefreshPostRequest apiAuthRefreshPostRequest = ; // ApiAuthRefreshPostRequest | 

try {
    api.apiAuthLogoutPost(apiAuthRefreshPostRequest);
} catch on DioException (e) {
    print('Exception when calling AuthApi->apiAuthLogoutPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiAuthRefreshPostRequest** | [**ApiAuthRefreshPostRequest**](ApiAuthRefreshPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiAuthRefreshPost**
> AuthResult apiAuthRefreshPost(apiAuthRefreshPostRequest)

刷新 access token

用 refresh token 换取新 access + refresh（rotation：旧 refresh 立即撤销）

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getAuthApi();
final ApiAuthRefreshPostRequest apiAuthRefreshPostRequest = ; // ApiAuthRefreshPostRequest | 

try {
    final response = api.apiAuthRefreshPost(apiAuthRefreshPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->apiAuthRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiAuthRefreshPostRequest** | [**ApiAuthRefreshPostRequest**](ApiAuthRefreshPostRequest.md)|  | 

### Return type

[**AuthResult**](AuthResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiAuthRegisterPost**
> AuthResult apiAuthRegisterPost(apiAuthRegisterPostRequest)

注册新账号

首次注册，返回 access + refresh token 并在服务端存 refresh token 哈希

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getAuthApi();
final ApiAuthRegisterPostRequest apiAuthRegisterPostRequest = ; // ApiAuthRegisterPostRequest | 

try {
    final response = api.apiAuthRegisterPost(apiAuthRegisterPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->apiAuthRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiAuthRegisterPostRequest** | [**ApiAuthRegisterPostRequest**](ApiAuthRegisterPostRequest.md)|  | 

### Return type

[**AuthResult**](AuthResult.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

