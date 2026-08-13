# health_helper_api.api.HealthApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiHealthRecordsGet**](HealthApi.md#apihealthrecordsget) | **GET** /api/health/records | 按 metric + 时间窗查询历史
[**apiHealthRecordsLatestGet**](HealthApi.md#apihealthrecordslatestget) | **GET** /api/health/records/latest | 查询某 metric 的最新一条
[**apiHealthRecordsPost**](HealthApi.md#apihealthrecordspost) | **POST** /api/health/records | 批量上报健康数据


# **apiHealthRecordsGet**
> ApiHealthRecordsGet200Response apiHealthRecordsGet(metric, from, to)

按 metric + 时间窗查询历史

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getHealthApi();
final HealthMetric metric = ; // HealthMetric | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.apiHealthRecordsGet(metric, from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HealthApi->apiHealthRecordsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **metric** | [**HealthMetric**](.md)|  | 
 **from** | **DateTime**|  | 
 **to** | **DateTime**|  | 

### Return type

[**ApiHealthRecordsGet200Response**](ApiHealthRecordsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiHealthRecordsLatestGet**
> ApiHealthRecordsLatestGet200Response apiHealthRecordsLatestGet(metric)

查询某 metric 的最新一条

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getHealthApi();
final HealthMetric metric = ; // HealthMetric | 

try {
    final response = api.apiHealthRecordsLatestGet(metric);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HealthApi->apiHealthRecordsLatestGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **metric** | [**HealthMetric**](.md)|  | 

### Return type

[**ApiHealthRecordsLatestGet200Response**](ApiHealthRecordsLatestGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiHealthRecordsPost**
> ApiHealthRecordsGet200Response apiHealthRecordsPost(apiHealthRecordsPostRequest)

批量上报健康数据

mobile 端从 HealthKit / Health Connect 同步时批量上报。上限 500 条/请求；steps 走专用 /api/exercises/steps 端点。

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getHealthApi();
final ApiHealthRecordsPostRequest apiHealthRecordsPostRequest = ; // ApiHealthRecordsPostRequest | 

try {
    final response = api.apiHealthRecordsPost(apiHealthRecordsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HealthApi->apiHealthRecordsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiHealthRecordsPostRequest** | [**ApiHealthRecordsPostRequest**](ApiHealthRecordsPostRequest.md)|  | 

### Return type

[**ApiHealthRecordsGet200Response**](ApiHealthRecordsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

