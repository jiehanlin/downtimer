import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);
    
    return Container(
      padding: const EdgeInsets.all(10), // 进一步减小padding
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF00FF41).withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 快捷时间设置按钮
          _buildQuickTimeButtons(timerModel),
          const SizedBox(height: 6), // 减小间距
          // 微调按钮
          _buildAdjustmentButtons(timerModel),
          const SizedBox(height: 6), // 减小间距
          // 控制按钮
          _buildControlButtons(timerModel),
        ],
      ),
    );
  }

  Widget _buildQuickTimeButtons(TimerModel timerModel) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          child: Text('${minutes}min'),
        );
      }).toList(),
    );
  }

  Widget _buildAdjustmentButtons(TimerModel timerModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => timerModel.subtractTime(1),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(Icons.remove, size: 20),
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF00FF41).withValues(alpha: 0.2)),
          ),
          child: Text(
            '${timerModel.totalSeconds ~/ 60} min',
            style: const TextStyle(
              color: Color(0xFF00FF41),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        ElevatedButton(
          onPressed: () => timerModel.addTime(1),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }

  Widget _buildControlButtons(TimerModel timerModel) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            timerModel.isRunning ? '暂停' : '开始',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        
        ElevatedButton(
          onPressed: timerModel.resetTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            foregroundColor: const Color(0xFF00FF41),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('重置', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}