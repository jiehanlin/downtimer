import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);
    final isCompact = MediaQuery.of(context).size.height < 320;
    
    return Container(
      padding: EdgeInsets.all(isCompact ? 4 : 8), // 根据高度动态调整padding
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF00FF41).withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 快捷时间设置按钮
          _buildQuickTimeButtons(timerModel, isCompact),
          SizedBox(height: isCompact ? 5 : 10),
          // 微调按钮
          _buildAdjustmentButtons(timerModel, isCompact),
          SizedBox(height: isCompact ? 5 : 10),
          // 控制按钮
          _buildControlButtons(timerModel, isCompact),
        ],
      ),
    );
  }

  Widget _buildQuickTimeButtons(TimerModel timerModel, bool isCompact) {
    return Wrap(
      spacing: isCompact ? 4 : 8,
      runSpacing: isCompact ? 2 : 4,
      children: TimerModel.quickTimes.map((minutes) {
        return ElevatedButton(
          onPressed: () => timerModel.setTime(minutes),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: const Color(0xFF00FF41).withValues(alpha: 0.3)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 6 : 10, 
              vertical: isCompact ? 2 : 4
            ),
            minimumSize: Size(isCompact ? 40 : 50, isCompact ? 20 : 28),
          ),
          child: Text(
            '${minutes}min',
            style: TextStyle(fontSize: isCompact ? 10 : 14),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdjustmentButtons(TimerModel timerModel, bool isCompact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => timerModel.subtractTime(1),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            shape: const CircleBorder(),
            padding: EdgeInsets.all(isCompact ? 6 : 10),
            minimumSize: Size(isCompact ? 32 : 40, isCompact ? 32 : 40),
          ),
          child: Icon(Icons.remove, size: isCompact ? 16 : 24),
        ),
        
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : 16, 
            vertical: isCompact ? 4 : 6
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF00FF41).withValues(alpha: 0.2)),
          ),
          child: Text(
            '${timerModel.totalSeconds ~/ 60} min',
            style: TextStyle(
              color: const Color(0xFF00FF41),
              fontWeight: FontWeight.bold,
              fontFamily: "NotoSansSC",
              fontSize: isCompact ? 10 : 14,
            ),
          ),
        ),
        
        ElevatedButton(
          onPressed: () => timerModel.addTime(1),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            shape: const CircleBorder(),
            padding: EdgeInsets.all(isCompact ? 6 : 10),
            minimumSize: Size(isCompact ? 32 : 40, isCompact ? 32 : 40),
          ),
          child: Icon(Icons.add, size: isCompact ? 16 : 24),
        ),
      ],
    );
  }

  Widget _buildControlButtons(TimerModel timerModel, bool isCompact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: timerModel.toggleTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: timerModel.isRunning 
                ? const Color(0xFFFF4444) 
                : const Color(0xFF00AA00),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 10 : 16, 
              vertical: isCompact ? 6 : 8
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            minimumSize: Size(isCompact ? 50 : 60, isCompact ? 24 : 32),
          ),
          child: Text(
            timerModel.isRunning ? '暂停' : '开始',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "NotoSansSC",
              fontSize: isCompact ? 10 : 14,
            ),
          ),
        ),
        
        ElevatedButton(
          onPressed: timerModel.resetTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 10 : 16, 
              vertical: isCompact ? 6 : 8
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            minimumSize: Size(isCompact ? 50 : 60, isCompact ? 24 : 32),
          ),
          child: Text(
            '重置', 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "NotoSansSC",
              fontSize: isCompact ? 10 : 14,
            ),
          ),
        ),
      ],
    );
  }
}