// Material 3 主题构建
//
// 设计要点：
// 1. **seed-derived ColorScheme**：用 AppColors.seed 自动派生 primary/secondary/tertiary
// 2. **明暗双主题**：buildLightTheme() + buildDarkTheme()，跟系统切换
// 3. **组件主题统一**：AppBar/Button/Input/Card 共用 AppDimens
// 4. **TextTheme 走 M3 命名**：displayLarge/headlineMedium/titleSmall/bodyMedium 等

import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData buildLightTheme() => _build(Brightness.light);
  static ThemeData buildDarkTheme() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: AppDimens.fontTitle,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      // 卡片
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
        ),
      ),
      // 按钮
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius8),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimens.fontBodyLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius8),
          ),
        ),
      ),
      // 输入框
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      // 文本
      textTheme: _buildTextTheme(colorScheme.onSurface),
    );
  }

  static TextTheme _buildTextTheme(Color base) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppDimens.fontDisplay,
        fontWeight: FontWeight.w700,
        color: base,
      ),
      headlineMedium: TextStyle(
        fontSize: AppDimens.fontHeading,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      titleLarge: TextStyle(
        fontSize: AppDimens.fontTitle,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      titleMedium: TextStyle(
        fontSize: AppDimens.fontBodyLarge,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      bodyLarge: TextStyle(
        fontSize: AppDimens.fontBodyLarge,
        color: base,
      ),
      bodyMedium: TextStyle(
        fontSize: AppDimens.fontBody,
        color: base,
      ),
      labelSmall: TextStyle(
        fontSize: AppDimens.fontCaption,
        color: base.withValues(alpha: 0.7),
      ),
    );
  }
}