import 'package:flutter/material.dart';
import 'theme_manager.dart';

/// 应用主题样式定义
/// 集中管理所有颜色、字体、尺寸等样式配置
class AppTheme {
  AppTheme._(); // 私有构造函数，防止实例化

  // ============ 基础颜色定义 ============
  
  /// 绿色主题的主色调
  static const Color greenPrimaryColor = Color(0xFF00FF41);
  
  /// 蓝色主题的主色调
  static const Color bluePrimaryColor = Color(0xFF00BFFF);
  
  /// 动态主色调 - 根据当前主题模式返回相应颜色
  static Color getPrimaryColor(ThemeManager themeManager) {
    return themeManager.isGreenTheme ? greenPrimaryColor : bluePrimaryColor;
  }
  
  /// 警告色 - 最后10秒的红色
  static const Color warningColor = Color(0xFFFF4444);
  
  /// 提醒色 - 最后1分钟的黄色
  static const Color cautionColor = Color(0xFFFFD700);
  
  /// 绿色主题的开始/运行状态
  static const Color greenStartColor = Color(0xFF00AA00);
  
  /// 蓝色主题的开始/运行状态
  static const Color blueStartColor = Color(0xFF0080FF);
  
  /// 动态开始/运行状态色
  static Color getStartColor(ThemeManager themeManager) {
    return themeManager.isGreenTheme ? greenStartColor : blueStartColor;
  }
  
  /// 暂停状态的颜色
  static const Color pauseColor = Color(0xFF00AA00);
  
  /// 背景色系
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color mediumBackground = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFF2A2A2A);
  static const Color panelBackground = Color(0xFF1A1A1A);
  
  /// 边框颜色 - 需要传入主题管理器
  static Color borderColorWithOpacity(ThemeManager themeManager, double opacity) => 
      getPrimaryColor(themeManager).withValues(alpha: opacity);
  
  /// 阴影颜色 - 需要传入主题管理器
  static Color shadowColorWithOpacity(ThemeManager themeManager, double opacity) => 
      getPrimaryColor(themeManager).withValues(alpha: opacity);

  // ============ 渐变背景 ============
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      darkBackground,
      mediumBackground,
    ],
  );

  // ============ 字体定义 ============
  
  /// LED数字字体
  static const String ledFontFamily = 'DSDigital';
  
  /// 中文字体
  static const String chineseFontFamily = 'NotoSansSC';
  
  /// LED数字样式
  static TextStyle ledTextStyle({
    required double fontSize,
    required Color color,
    double height = 1.0,
  }) {
    return TextStyle(
      fontFamily: ledFontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      height: height,
      shadows: _getTextShadows(color),
    );
  }
  
  /// 冒号字体样式
  static TextStyle colonTextStyle({
    required double fontSize,
    required Color color,
    bool isVisible = true,
  }) {
    final adjustedFontSize = fontSize * 0.8 < 15 ? fontSize * 1.2 : fontSize * 0.8;
    return TextStyle(
      fontFamily: ledFontFamily,
      fontSize: adjustedFontSize,
      fontWeight: FontWeight.bold,
      color: isVisible ? color : color.withValues(alpha: 0.2),
      shadows: isVisible ? _getTextShadows(color) : null,
    );
  }
  
  /// 按钮文本样式
  static TextStyle buttonText({
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: chineseFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
  
  /// 标题样式 - 需要传入主题管理器
  static TextStyle titleStyle(ThemeManager themeManager) {
    return TextStyle(
      color: getPrimaryColor(themeManager),
      fontWeight: FontWeight.bold,
      fontFamily: chineseFontFamily,
    );
  }

  // ============ 按钮样式 ============
  
  /// 主要按钮样式（开始/暂停按钮）
  static ButtonStyle primaryButtonStyle({
    required ThemeManager themeManager,
    required bool isRunning,
    double horizontalPadding = 16.0,
    double verticalPadding = 8.0,
    double minWidth = 60.0,
    double minHeight = 32.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: isRunning ? AppTheme.warningColor : getStartColor(themeManager),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      minimumSize: Size(minWidth, minHeight),
    );
  }
  
  /// 次要按钮样式（重置按钮）
  static ButtonStyle secondaryButtonStyle({
    required ThemeManager themeManager,
    double horizontalPadding = 16.0,
    double verticalPadding = 8.0,
    double minWidth = 60.0,
    double minHeight = 32.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: lightBackground,
      foregroundColor: getPrimaryColor(themeManager),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      minimumSize: Size(minWidth, minHeight),
    );
  }
  
  /// 快捷时间按钮样式
  static ButtonStyle quickTimeButtonStyle({
    required ThemeManager themeManager,
    double horizontalPadding = 10.0,
    double verticalPadding = 4.0,
    double minWidth = 50.0,
    double minHeight = 28.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: lightBackground,
      foregroundColor: getPrimaryColor(themeManager),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: borderColorWithOpacity(themeManager, 0.3)),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      minimumSize: Size(minWidth, minHeight),
    );
  }
  
  /// 圆形按钮样式（加减按钮）
  static ButtonStyle circleButtonStyle({
    required ThemeManager themeManager,
    double padding = 10.0,
    double size = 40.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: lightBackground,
      foregroundColor: getPrimaryColor(themeManager),
      shape: const CircleBorder(),
      padding: EdgeInsets.all(padding),
      minimumSize: Size(size, size),
    );
  }

  // ============ 容器样式 ============
  
  /// LED显示容器样式
  static BoxDecoration ledContainerStyle({
    required Color backgroundColor,
    required Color borderColor,
    double borderRadius = 8.0,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor.withValues(alpha: 0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: borderColor.withValues(alpha: 0.2),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  /// 控制面板容器样式
  static BoxDecoration controlPanelStyle(ThemeManager themeManager) {
    return BoxDecoration(
      color: panelBackground,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: borderColorWithOpacity(themeManager, 0.2), width: 1),
    );
  }
  
  /// LED数字单个容器样式
  static BoxDecoration ledDigitStyle({
    required Color borderColor,
    double borderRadius = 4.0,
  }) {
    return BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor.withValues(alpha: 0.1), width: 1),
    );
  }
  
  /// 时间显示容器样式
  static BoxDecoration timeDisplayStyle({
    required Color borderColor,
  }) {
    return BoxDecoration(
      color: darkBackground,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: borderColor.withValues(alpha: 0.2)),
    );
  }

  // ============ 间距定义 ============
  
  /// 标准间距
  static const double spacingXS = 2.0;
  static const double spacingS = 4.0;
  static const double spacingM = 8.0;
  static const double spacingL = 12.0;
  static const double spacingXL = 16.0;
  static const double spacingXXL = 20.0;
  
  /// LED相关间距
  static const double ledDigitSpacing = 4.0;
  static const double ledHorizontalPadding = 6.0;
  static const double ledVerticalPadding = 3.0;
  static const double ledHorizontalPaddingSmall = 2.0;
  static const double ledVerticalPaddingSmall = 1.0;
  
  /// 控制面板间距
  static const double controlPanelPadding = 10.0;
  static const double controlPanelPaddingSmall = 4.0;
  
  /// LED容器尺寸比例
  static const double ledDigitWidthRatio = 0.72;
  static const double ledDigitHeightRatio = 1.2;
  static const double ledColonWidthRatio = 0.36;
  static const double ledColonHeightRatio = 1.2;
  static const double ledColonFontSizeRatio = 0.8;

  // ============ 动画配置 ============
  
  /// 动画持续时间
  static const Duration normalAnimationDuration = Duration(milliseconds: 1000);
  static const Duration fastAnimationDuration = Duration(milliseconds: 500);
  static const Duration slowAnimationDuration = Duration(milliseconds: 2000);
  
  /// 脉冲动画范围
  static const double pulseAnimationBegin = 1.0;
  static const double pulseAnimationEnd = 1.1;
  
  /// 警告状态的阴影配置
  static const double warningShadowBlur = 20.0;
  static const double warningShadowSpread = 4.0;
  static const double normalShadowBlur = 10.0;
  static const double normalShadowSpread = 2.0;

  // ============ 私有辅助方法 ============
  
  /// 获取文本阴影
  static List<Shadow> _getTextShadows(Color color) {
    return [
      Shadow(
        blurRadius: 10,
        color: color.withValues(alpha: 0.8),
      ),
      Shadow(
        blurRadius: 20,
        color: color.withValues(alpha: 0.4),
      ),
    ];
  }

  // ============ 响应式配置 ============
}

/// 紧凑模式的尺寸配置
class CompactSizes {
  const CompactSizes();
  
  double get buttonPaddingHorizontal => 6.0;
  double get buttonPaddingVertical => 2.0;
  double get buttonMinWidth => 40.0;
  double get buttonMinHeight => 20.0;
  double get circleButtonPadding => 6.0;
  double get circleButtonSize => 32.0;
  double get controlButtonPaddingHorizontal => 10.0;
  double get controlButtonPaddingVertical => 6.0;
  double get controlButtonMinWidth => 50.0;
  double get controlButtonMinHeight => 24.0;
  double get controlPanelPadding => 4.0;
  double get fontSize => 10.0;
  double get iconSize => 16.0;
  double get timeDisplayHorizontal => 8.0;
  double get timeDisplayVertical => 4.0;
  double get spacing => 2.0;
}

/// 标准模式的尺寸配置
class StandardSizes {
  const StandardSizes();
  
  double get buttonPaddingHorizontal => 10.0;
  double get buttonPaddingVertical => 4.0;
  double get buttonMinWidth => 50.0;
  double get buttonMinHeight => 28.0;
  double get circleButtonPadding => 10.0;
  double get circleButtonSize => 40.0;
  double get controlButtonPaddingHorizontal => 16.0;
  double get controlButtonPaddingVertical => 8.0;
  double get controlButtonMinWidth => 60.0;
  double get controlButtonMinHeight => 32.0;
  double get controlPanelPadding => 8.0;
  double get fontSize => 12.0;
  double get iconSize => 20.0;
  double get timeDisplayHorizontal => 16.0;
  double get timeDisplayVertical => 6.0;
  double get spacing => 4.0;
}