// 间距 / 圆角 / 字号 —— 全局尺寸系统
//
// 设计要点：
// 1. **4 像素栅格**：所有 spacing 是 4 的倍数（4/8/12/16/24/32）
// 2. **字号阶梯**：12/14/16/20/24/32 — 满足正文/标题/数字大屏
// 3. **圆角 3 级**：8（按钮输入）/12（卡片）/16（对话框）—— 与 M3 默认对齐
// 4. **icon 3 档**：16（行内）/24（按钮）/32（大屏）

class AppDimens {
  AppDimens._();

  // spacing
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space48 = 48;

  // radius
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;

  // font sizes
  static const double fontCaption = 12;
  static const double fontBody = 14;
  static const double fontBodyLarge = 16;
  static const double fontTitle = 20;
  static const double fontHeading = 24;
  static const double fontDisplay = 32;

  // icon sizes
  static const double icon16 = 16;
  static const double icon24 = 24;
  static const double icon32 = 32;

  // component sizes
  static const double inputHeight = 56;
  static const double buttonHeight = 48;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
}