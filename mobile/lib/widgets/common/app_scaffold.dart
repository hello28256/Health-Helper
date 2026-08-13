// AppScaffold —— 统一 AppBar + Scaffold 封装
//
// 设计要点：
// - 所有页面统一 AppBar 高度 / 标题样式（已在 theme 里设好，这里只是引用）
// - 支持可选 actions（右上角按钮列表）
// - 支持 bottom（TabBar / 搜索框等）

import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
    this.floatingActionButton,
    this.appBar,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottom;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: Text(title),
            actions: actions,
            bottom: bottom is PreferredSizeWidget
                ? bottom as PreferredSizeWidget
                : null,
          ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}