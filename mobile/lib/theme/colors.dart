// 应用色板 —— Material 3 seed-derived + 业务语义色
//
// 设计要点：
// 1. **种子色驱动**：用 Color(0xFF4CAF50)（健康绿）作为 M3 ColorScheme.fromSeed 的 seed
// 2. **业务语义色**：success/warning/danger 不依赖 primary，方便复用
// 3. **中性与表面**：背景/卡片/分隔线层级清晰，dashboard 多卡片场景不糊

import 'package:flutter/material.dart';

/// 业务语义色（与 primary 解耦，便于复用与暗色变体）
class AppColors {
  AppColors._();

  // 业务语义
  static const Color success = Color(0xFF2E7D32); // 健康绿（深）
  static const Color warning = Color(0xFFF57C00); // 橙
  static const Color danger = Color(0xFFD32F2F); // 红
  static const Color info = Color(0xFF1976D2); // 蓝

  // 数据可视化（图表）
  static const Color chartSteps = Color(0xFF4CAF50);
  static const Color chartKcal = Color(0xFFFF7043);
  static const Color chartMood = Color(0xFFAB47BC);
  static const Color chartSleep = Color(0xFF5C6BC0);

  // 中性
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral900 = Color(0xFF212121);

  // M3 seed
  static const Color seed = Color(0xFF2E7D32); // 深健康绿（对比度更好）
}