import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class LEDDisplay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDigits(),
        ),
      ),
    );
  }

  List<Widget> _buildDigits() {
    List<Widget> digits = [];
    
    for (int i = 0; i < timeString.length; i++) {
      final char = timeString[i];
      
      // 如果是冒号，使用特殊样式显示
      if (char == ':') {
        digits.add(_buildColon());
      } else {
        digits.add(_buildDigit(char));
      }
      
      // 在数字之间添加间距，但冒号前后不需要额外间距，减少间距避免溢出
      if (i < timeString.length - 1 && char != ':' && timeString[i + 1] != ':') {
        digits.add(const SizedBox(width: 4)); // 减少间距从8到4
      }
    }
    
    return digits;
  }

  Widget _buildDigit(String digit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // 减少padding避免溢出
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Text(
        digit,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.0, // 减少行高
          shadows: [
            Shadow(
              blurRadius: 10,
              color: color.withValues(alpha: 0.8),
            ),
            Shadow(
              blurRadius: 20,
              color: color.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColon() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: fontSize * 0.8,
          fontWeight: FontWeight.bold,
          color: color,
          shadows: [
            Shadow(
              blurRadius: 10,
              color: color.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}