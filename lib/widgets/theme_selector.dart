import 'package:flutter/material.dart';
import '../theme/theme_manager.dart';
import '../theme/app_theme.dart';

/// 紧凑型主题选择器组件
class CompactThemeSelector extends StatelessWidget {
  final ThemeManager themeManager;
  
  const CompactThemeSelector({
    super.key,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 绿色主题选项
        _CompactThemeOption(
          color: AppTheme.greenPrimaryColor,
          isSelected: themeManager.isGreenTheme,
          onTap: themeManager.setGreenTheme,
        ),
        
        const SizedBox(width: 8),
        
        // 蓝色主题选项
        _CompactThemeOption(
          color: AppTheme.bluePrimaryColor,
          isSelected: themeManager.isBlueTheme,
          onTap: themeManager.setBlueTheme,
        ),
      ],
    );
  }
}

/// 紧凑型主题选项子组件
class _CompactThemeOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompactThemeOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : color.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: isSelected ? 6 : 3,
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}