import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';
import '../theme/app_theme.dart';
import '../theme/theme_manager.dart';

class LEDDisplay extends StatefulWidget {
  final String timeString;
  final double fontSize;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final VoidCallback? onDoubleTap;

  const LEDDisplay({
    super.key,
    required this.timeString,
    required this.fontSize,
    this.color,
    this.backgroundColor,
    this.padding,
    this.onDoubleTap,
  });

  @override
  State<LEDDisplay> createState() => _LEDDisplayState();
}

class _LEDDisplayState extends State<LEDDisplay> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: AppTheme.normalAnimationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: AppTheme.pulseAnimationBegin,
      end: AppTheme.pulseAnimationEnd,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // 启动持续的冒号闪烁动画
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Consumer2<TimerModel, ThemeManager>(
      builder: (context, timerModel, themeManager, child) {
        // 直接获取当前颜色，不依赖动画
        final currentColor = _getCurrentColor(timerModel, themeManager);
        
        return GestureDetector(
          onDoubleTap: widget.onDoubleTap,
          onPanStart: (details) {
            windowManager.startDragging();
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // 使用简单的颜色计算，确保主题变化时立即更新
              final displayColor = _getDisplayColor(currentColor, timerModel);
              
              return Transform.scale(
                scale: (timerModel.isTenSecondsWarning || timerModel.isOneMinuteWarning) 
                    ? _pulseAnimation.value 
                    : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? AppTheme.darkBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: displayColor.withValues(alpha: 0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: displayColor.withValues(alpha: 0.2),
                        blurRadius: timerModel.isTenSecondsWarning 
                            ? AppTheme.warningShadowBlur 
                            : AppTheme.normalShadowBlur,
                        spreadRadius: timerModel.isTenSecondsWarning 
                            ? AppTheme.warningShadowSpread 
                            : AppTheme.normalShadowSpread,
                      ),
                    ],
                  ),
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDigits(displayColor),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  
  // 获取当前基础颜色
  Color _getCurrentColor(TimerModel timerModel, ThemeManager themeManager) {
    // 优先检查警告状态，确保警告颜色始终显示
    if (timerModel.isTenSecondsWarning) {
      return AppTheme.warningColor;
    } else if (timerModel.isOneMinuteWarning) {
      return AppTheme.cautionColor;
    }
    
    // 如果手动指定了颜色（例如从外部传入的主题色）
    if (widget.color != null) {
      return widget.color!;
    }
    
    // 默认使用主题色
    return AppTheme.getPrimaryColor(themeManager);
  }
  
  // 获取显示颜色（考虑冒号闪烁）
  Color _getDisplayColor(Color baseColor, TimerModel timerModel) {
    // 对于冒号的闪烁处理在_buildColon方法中处理
    return baseColor;
  }

  List<Widget> _buildDigits(Color currentColor) {
    List<Widget> digits = [];
    
    for (int i = 0; i < widget.timeString.length; i++) {
      final char = widget.timeString[i];
      
      // 如果是冒号，使用特殊样式显示
      if (char == ':') {
        digits.add(_buildColon(currentColor));
      } else {
        digits.add(_buildDigit(char, currentColor));
      }
      
      // 在数字之间添加间距，但冒号前后不需要额外间距，减少间距避免溢出
      if (i < widget.timeString.length - 1 && char != ':' && widget.timeString[i + 1] != ':') {
        digits.add(const SizedBox(width: AppTheme.ledDigitSpacing)); // 使用主题定义的间距
      }
    }
    
    return digits;
  }

  Widget _buildDigit(String digit, Color currentColor) {
    final isCompact = widget.fontSize < 20;
    
    return Container(
      width: widget.fontSize * AppTheme.ledDigitWidthRatio,
      height: widget.fontSize * AppTheme.ledDigitHeightRatio,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppTheme.ledHorizontalPaddingSmall : AppTheme.ledHorizontalPadding,
        vertical: isCompact ? AppTheme.ledVerticalPaddingSmall : AppTheme.ledVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: currentColor.withValues(alpha: 0.1), width: 1),
      ),
      child: FittedBox( // 使用FittedBox确保字体在容器内完整显示
        fit: BoxFit.scaleDown,
        child: Text(
          digit,
          style: TextStyle(
            fontFamily: AppTheme.ledFontFamily,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: currentColor,
            height: 1.0,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: currentColor.withValues(alpha: 0.8),
              ),
              Shadow(
                blurRadius: 20,
                color: currentColor.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColon(Color currentColor) {
    // 使用动画控制器的值来控制闪烁
    final shouldBlink = (_animationController.value * 2).floor() % 2 == 0;
    final isCompact = widget.fontSize < 20;
    
    return Container(
      width: widget.fontSize * AppTheme.ledColonWidthRatio, // 冒号的固定宽度
      height: widget.fontSize * AppTheme.ledColonHeightRatio, // 与数字相同的高度
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 1 : 4, // 超小模式下减少padding
      ),
      child: FittedBox( // 使用FittedBox确保冒号在容器内完整显示
        fit: BoxFit.scaleDown,
        child: Text(
          ':',
          style: TextStyle(
            fontFamily: AppTheme.ledFontFamily,
            fontSize: widget.fontSize * 0.8 < 15 ? widget.fontSize * 1.2 : widget.fontSize * 0.8,
            fontWeight: FontWeight.bold,
            color: shouldBlink ? currentColor : currentColor.withValues(alpha: 0.2),
            shadows: shouldBlink ? [
              Shadow(
                blurRadius: 10,
                color: currentColor.withValues(alpha: 0.8),
              ),
            ] : null,
          ),
        ),
      ),
    );
  }
}