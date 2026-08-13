// AppTheme 单元测试 —— 验证：
// 1. buildLightTheme() 返回 ThemeData 且 useMaterial3=true
// 2. buildDarkTheme() 返回 ThemeData 且 brightness=dark
// 3. 明暗主题 ColorScheme 不同
// 4. AppBar / Button / Input 主题继承 AppDimens 尺寸
// 5. TextTheme 应用全局字号

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/theme/app_theme.dart';
import 'package:health_helper/theme/dimens.dart';

void main() {
  test('buildLightTheme 返回 M3 ThemeData', () {
    final theme = AppTheme.buildLightTheme();
    expect(theme.useMaterial3, true);
    expect(theme.brightness, Brightness.light);
  });

  test('buildDarkTheme 返回 M3 ThemeData', () {
    final theme = AppTheme.buildDarkTheme();
    expect(theme.useMaterial3, true);
    expect(theme.brightness, Brightness.dark);
  });

  test('明暗主题 ColorScheme 不同', () {
    final light = AppTheme.buildLightTheme();
    final dark = AppTheme.buildDarkTheme();
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
    expect(
      light.colorScheme.primary,
      isNot(equals(dark.colorScheme.primary)),
    );
  });

  test('ElevatedButton 最小高度 = AppDimens.buttonHeight', () {
    final theme = AppTheme.buildLightTheme();
    final style = theme.elevatedButtonTheme.style;
    expect(style?.minimumSize?.resolve({})?.height, AppDimens.buttonHeight);
  });

  test('InputDecoration 内容 padding 含 space16', () {
    final theme = AppTheme.buildLightTheme();
    final pad = theme.inputDecorationTheme.contentPadding;
    // Flutter 会自动把 horizontal ×2（DPR 无关的内边距）
    expect(pad?.horizontal, AppDimens.space16 * 2);
  });

  test('AppBar elevation = 0', () {
    final theme = AppTheme.buildLightTheme();
    expect(theme.appBarTheme.elevation, 0);
  });

  test('TextTheme 应用 M3 命名 + 全局字号', () {
    final theme = AppTheme.buildLightTheme();
    expect(theme.textTheme.displayLarge?.fontSize, AppDimens.fontDisplay);
    expect(theme.textTheme.bodyMedium?.fontSize, AppDimens.fontBody);
    expect(theme.textTheme.titleLarge?.fontSize, AppDimens.fontTitle);
  });
}