// Loading —— 居中加载指示器
//
// 用法：`const Loading()` 嵌在 Scaffold.body 或 Column 里

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}