import 'dart:async';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TimerModel with ChangeNotifier {
  int _totalSeconds = 0; // 总秒数
  int _remainingSeconds = 0; // 剩余秒数
  Timer? _timer;
  bool _isRunning = false;
  int _displayMode = 0; // 0: 正常模式, 1: 最小化模式, 2: 超小模式

  // 快捷时间设置（分钟）
  static const List<int> quickTimes = [3, 5, 8, 15, 20,30];

  int get totalSeconds => _totalSeconds;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  int get displayMode => _displayMode;

  // 警告状态检测
  bool get isOneMinuteWarning => _remainingSeconds <= 60 && _remainingSeconds > 10;
  bool get isTenSecondsWarning => _remainingSeconds <= 10 && _remainingSeconds > 0;

  // 获取格式化时间字符串
  String get formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 设置时间（分钟）
  void setTime(int minutes) {
    if (minutes < 0 || minutes > 60) return;
    
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _stopTimer();
    notifyListeners();
  }

  // 增加时间（分钟）
  void addTime(int minutes) {
    int newTotalSeconds = _totalSeconds + (minutes * 60);
    if (newTotalSeconds > 3600) return; // 最大1小时
    
    _totalSeconds = newTotalSeconds;
    _remainingSeconds = _totalSeconds;
    _stopTimer();
    notifyListeners();
  }

  // 减少时间（分钟）
  void subtractTime(int minutes) {
    int newTotalSeconds = _totalSeconds - (minutes * 60);
    if (newTotalSeconds < 0) return;
    
    _totalSeconds = newTotalSeconds;
    _remainingSeconds = _totalSeconds;
    _stopTimer();
    notifyListeners();
  }

  // 开始/暂停计时器
  void toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  // 重置计时器
  void resetTimer() {
    _stopTimer();
    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  // 直接设置窗口模式
  void setDisplayMode(int mode) async {
    if (mode < 0 || mode > 2) return;
    
    _displayMode = mode;
    
    switch (_displayMode) {
      case 0: // 正常模式
        await windowManager.setSize(const Size(450, 330));
        await windowManager.setAlignment(Alignment.center);
        break;
      case 1: // 最小化模式
        await windowManager.setSize(const Size(400, 130));
        await windowManager.setAlignment(Alignment.center);
        break;
      case 2: // 超小模式
        await windowManager.setSize(const Size(200, 60));
        await windowManager.setAlignment(Alignment.center);
        break;
    }
    
    notifyListeners();
  }

  // 从正常模式切换到最小化模式
  void minimizeWindow() {
    if (_displayMode == 0) {
      setDisplayMode(1);
    }
  }

  // 从最小化模式切换到超小模式
  void ultraMinimizeWindow() {
    if (_displayMode == 1) {
      setDisplayMode(2);
    }
  }

  // 从最小化或超小模式回到正常模式
  void restoreWindow() {
    if (_displayMode != 0) {
      setDisplayMode(0);
    }
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) return;
    
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _stopTimer();
        // 计时结束处理
        _onTimerFinished();
      }
    });
    notifyListeners();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();
  }

  void _onTimerFinished() {
    // 计时结束，可以添加通知或声音
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}