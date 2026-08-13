// AsyncValueWidget —— AsyncValue<T> 三态自动分发
//
// 设计要点：
// - loading → Loading
// - error → ErrorView（自动从 ApiError 提取 message，可选重试）
// - data → 用户提供的 builder(data)
// - skipLoadingOnRefresh：当 AsyncData/AsyncLoading 切换时不显示 loading（避免刷新闪烁）
// - skipError：用于"已有缓存数据时静默刷新"的场景

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_error.dart';
import 'error_view.dart';
import 'loading.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.skipLoadingOnRefresh = true,
    this.skipError = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final bool skipLoadingOnRefresh;
  final bool skipError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () {
        // skipLoadingOnRefresh + 已有数据 → 显示旧数据，不闪
        if (skipLoadingOnRefresh && value.hasValue) {
          return data(value.requireValue);
        }
        return const Loading();
      },
      error: (err, _) {
        if (skipError && value.hasValue) {
          return data(value.requireValue);
        }
        final message = err is ApiError ? err.message : err.toString();
        return ErrorView(message: message, onRetry: onRetry);
      },
    );
  }
}