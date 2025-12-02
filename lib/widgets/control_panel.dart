import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';
import '../theme/app_theme.dart';
import '../theme/theme_manager.dart';
import 'theme_selector.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final isCompact = MediaQuery.of(context).size.height < 320;
    
    return Container(
      padding: EdgeInsets.all(isCompact ? 4 : 8),
      decoration: AppTheme.controlPanelStyle(themeManager),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 快捷时间设置按钮
          _buildQuickTimeButtons(timerModel, themeManager, isCompact),
          SizedBox(height: isCompact ? 2 : 10),
          // 微调按钮
          _buildAdjustmentButtons(timerModel, themeManager, isCompact),
          SizedBox(height: isCompact ? 2 : 8),
          // 控制按钮（包含主题选择器）
          _buildControlButtonsWithTheme(timerModel, themeManager, isCompact),
        ],
      ),
    );
  }

  Widget _buildQuickTimeButtons(TimerModel timerModel, ThemeManager themeManager, bool isCompact) {
    return Wrap(
      spacing: isCompact ? 4 : 8,
      runSpacing: isCompact ? 2 : 4,
      children: TimerModel.quickTimes.map((minutes) {
        return ElevatedButton(
          onPressed: () => timerModel.setTime(minutes),
          style: AppTheme.quickTimeButtonStyle(
            themeManager: themeManager,
            horizontalPadding: isCompact ? 6 : 10,
            verticalPadding: isCompact ? 2 : 4,
            minWidth: isCompact ? 40 : 50,
            minHeight: isCompact ? 20 : 28,
          ),
          child: Text(
            '${minutes}min',
            style: TextStyle(fontSize: isCompact ? 10 : 14),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdjustmentButtons(TimerModel timerModel, ThemeManager themeManager, bool isCompact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => timerModel.subtractTime(1),
          style: AppTheme.circleButtonStyle(
            themeManager: themeManager,
            padding: isCompact ? 6 : 10,
            size: isCompact ? 32 : 40,
          ),
          child: Icon(Icons.remove, size: isCompact ? 16 : 24),
        ),
        
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : 16, 
            vertical: isCompact ? 4 : 6
          ),
          decoration: BoxDecoration(
            color: AppTheme.darkBackground,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppTheme.borderColorWithOpacity(themeManager, 0.2)),
          ),
          child: Text(
            '${timerModel.totalSeconds ~/ 60} min',
            style: TextStyle(
              color: AppTheme.getPrimaryColor(themeManager),
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.chineseFontFamily,
              fontSize: isCompact ? 10 : 14,
            ),
          ),
        ),
        
        ElevatedButton(
          onPressed: () => timerModel.addTime(1),
          style: AppTheme.circleButtonStyle(
            themeManager: themeManager,
            padding: isCompact ? 6 : 10,
            size: isCompact ? 32 : 40,
          ),
          child: Icon(Icons.add, size: isCompact ? 16 : 24),
        ),
      ],
    );
  }

  Widget _buildControlButtonsWithTheme(TimerModel timerModel, ThemeManager themeManager, bool isCompact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 开始/暂停按钮
        ElevatedButton(
          onPressed: timerModel.toggleTimer,
          style: AppTheme.primaryButtonStyle(
            themeManager: themeManager,
            isRunning: timerModel.isRunning,
            horizontalPadding: isCompact ? 10 : 16,
            verticalPadding: isCompact ? 6 : 8,
            minWidth: isCompact ? 50 : 60,
            minHeight: isCompact ? 24 : 32,
          ),
          child: Text(
            timerModel.isRunning ? '暂停' : '开始',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.chineseFontFamily,
              fontSize: isCompact ? 10 : 14,
            ),
          ),
        ),
        
        // 紧凑型主题选择器 - 在紧凑模式下也显示
        if (!isCompact) ...[
          const SizedBox(width: 8),
          CompactThemeSelector(themeManager: themeManager),
          const SizedBox(width: 8),
        ] else ...[
          const SizedBox(width: 4),
          CompactThemeSelector(themeManager: themeManager),
          const SizedBox(width: 4),
        ],
        
        // 重置按钮
        ElevatedButton(
          onPressed: timerModel.resetTimer,
          style: AppTheme.secondaryButtonStyle(
            themeManager: themeManager,
            horizontalPadding: isCompact ? 10 : 16,
            verticalPadding: isCompact ? 6 : 8,
            minWidth: isCompact ? 50 : 60,
            minHeight: isCompact ? 24 : 32,
          ),
          child: Text(
            '重置', 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.chineseFontFamily,
              fontSize: isCompact ? 10 : 14,
            ),
          ),
        ),
      ],
    );
  }
}