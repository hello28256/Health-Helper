# health_helper_api.api.DietApi

## Load the API package
```dart
import 'package:health_helper_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiDietFoodsGet**](DietApi.md#apidietfoodsget) | **GET** /api/diet/foods | 搜索食物营养库
[**apiDietRecordsGet**](DietApi.md#apidietrecordsget) | **GET** /api/diet/records | 查询某时间段的饮食记录
[**apiDietRecordsPost**](DietApi.md#apidietrecordspost) | **POST** /api/diet/records | 记录一餐
[**apiDietSummaryGet**](DietApi.md#apidietsummaryget) | **GET** /api/diet/summary | 查询某日营养汇总


# **apiDietFoodsGet**
> ApiDietFoodsGet200Response apiDietFoodsGet(q, category, limit, offset)

搜索食物营养库

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getDietApi();
final String q = q_example; // String | 匹配 nameZh 或 name
final String category = category_example; // String | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.apiDietFoodsGet(q, category, limit, offset);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DietApi->apiDietFoodsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| 匹配 nameZh 或 name | [optional] 
 **category** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**ApiDietFoodsGet200Response**](ApiDietFoodsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiDietRecordsGet**
> ApiDietRecordsGet200Response apiDietRecordsGet(from, to)

查询某时间段的饮食记录

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getDietApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.apiDietRecordsGet(from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DietApi->apiDietRecordsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | 
 **to** | **DateTime**|  | 

### Return type

[**ApiDietRecordsGet200Response**](ApiDietRecordsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiDietRecordsPost**
> DietRecord apiDietRecordsPost(apiDietRecordsPostRequest)

记录一餐

服务端计算 consumed = servings × servingSizeG/100 × per100g

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getDietApi();
final ApiDietRecordsPostRequest apiDietRecordsPostRequest = ; // ApiDietRecordsPostRequest | 

try {
    final response = api.apiDietRecordsPost(apiDietRecordsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DietApi->apiDietRecordsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiDietRecordsPostRequest** | [**ApiDietRecordsPostRequest**](ApiDietRecordsPostRequest.md)|  | 

### Return type

[**DietRecord**](DietRecord.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiDietSummaryGet**
> DailyNutritionSummary apiDietSummaryGet(date)

查询某日营养汇总

### Example
```dart
import 'package:health_helper_api/api.dart';

final api = HealthHelperApi().getDietApi();
final DateTime date = 2013-10-20T19:20:30+01:00; // DateTime | 默认今天

try {
    final response = api.apiDietSummaryGet(date);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DietApi->apiDietSummaryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**| 默认今天 | [optional] 

### Return type

[**DailyNutritionSummary**](DailyNutritionSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

