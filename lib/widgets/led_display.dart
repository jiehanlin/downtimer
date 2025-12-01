import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';

class LEDDisplay extends StatefulWidget {
  final String timeString;
  final double fontSize;
  final Color color;
  final Color backgroundColor;
  final EdgeInsets padding;
  final VoidCallback? onDoubleTap;

  const LEDDisplay({
    super.key,
    required this.timeString,
    required this.fontSize,
    this.color = const Color(0xFF00FF41),
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.padding = const EdgeInsets.all(16),
    this.onDoubleTap,
  });

  @override
  State<LEDDisplay> createState() => _LEDDisplayState();
}

class _LEDDisplayState extends State<LEDDisplay> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.color,
      end: widget.color,
    ).animate(_animationController);

    // 启动持续的冒号闪烁动画
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LEDDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimation();
  }

  void _updateAnimation() {
    final timerModel = Provider.of<TimerModel>(context, listen: false);
    Color targetColor;
    int duration;

    if (timerModel.isTenSecondsWarning) {
      targetColor = const Color(0xFFFF4444);
      duration = 500; // 快速闪烁
    } else if (timerModel.isOneMinuteWarning) {
      targetColor = const Color(0xFFFFD700);
      duration = 2000; // 慢速闪烁
    } else {
      targetColor = widget.color;
      duration = 1000; // 正常状态下的冒号闪烁频率
    }

    _colorAnimation = ColorTween(
      begin: widget.color,
      end: targetColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.duration = Duration(milliseconds: duration);
    
    // 始终保持动画运行，确保冒号持续闪烁
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(
      builder: (context, timerModel, child) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final currentColor = _colorAnimation.value ?? widget.color;
            
            return GestureDetector(
              onDoubleTap: widget.onDoubleTap,
              onPanStart: (details) {
                windowManager.startDragging();
              },
              child: Transform.scale(
                scale: (timerModel.isTenSecondsWarning || timerModel.isOneMinuteWarning) 
                    ? _pulseAnimation.value 
                    : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: currentColor.withValues(alpha: 0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: currentColor.withValues(alpha: 0.2),
                        blurRadius: timerModel.isTenSecondsWarning ? 20 : 10,
                        spreadRadius: timerModel.isTenSecondsWarning ? 4 : 2,
                      ),
                    ],
                  ),
                  padding: widget.padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDigits(currentColor),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
        digits.add(const SizedBox(width: 4)); // 减少间距从8到4
      }
    }
    
    return digits;
  }

  Widget _buildDigit(String digit, Color currentColor) {
    return Container(
      width: widget.fontSize * 0.72, // 固定宽度，0.6太小，0.8太大，设为0.72
      height: widget.fontSize * 1.2, // 固定高度
      padding: EdgeInsets.symmetric(
        horizontal: widget.fontSize < 20 ? 2 : 6, // 超小模式下减少padding
        vertical: widget.fontSize < 20 ? 1 : 3,
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
            fontFamily: 'DSDigital',
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
    
    return Container(
      width: widget.fontSize * 0.36, // 冒号的固定宽度，按0.72的0.5比例调整
      height: widget.fontSize * 1.2, // 与数字相同的高度
      padding: EdgeInsets.symmetric(
        horizontal: widget.fontSize < 20 ? 1 : 4, // 超小模式下减少padding
      ),
      child: FittedBox( // 使用FittedBox确保冒号在容器内完整显示
        fit: BoxFit.scaleDown,
        child: Text(
          ':',
          style: TextStyle(
            fontFamily: 'DSDigital',
            fontSize: widget.fontSize * 0.8<15?widget.fontSize * 1.2 : widget.fontSize * 0.8,
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