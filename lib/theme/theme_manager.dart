import 'package:flutter/material.dart';

/// 应用主题模式枚举
enum AppThemeMode { green, blue }

/// 主题管理器 - 使用单例模式管理应用主题状态
class ThemeManager with ChangeNotifier {
  // 单例实例
  static final ThemeManager _instance = ThemeManager._internal();
  
  // 工厂构造函数返回单例
  factory ThemeManager() => _instance;
  
  // 私有命名构造函数
  ThemeManager._internal() {
    // 初始化时可以从本地存储加载用户偏好设置
    // 这里暂时使用默认的绿色主题
    _currentTheme = AppThemeMode.green;
  }
  
  // 当前主题模式
  AppThemeMode _currentTheme = AppThemeMode.green;
  
  // 获取当前主题模式
  AppThemeMode get currentTheme => _currentTheme;
  
  // 获取当前主题是否为绿色
  bool get isGreenTheme => _currentTheme == AppThemeMode.green;
  
  // 获取当前主题是否为蓝色
  bool get isBlueTheme => _currentTheme == AppThemeMode.blue;
  
  /// 切换到绿色主题
  void setGreenTheme() {
    if (_currentTheme != AppThemeMode.green) {
      _currentTheme = AppThemeMode.green;
      notifyListeners();
    }
  }
  
  /// 切换到蓝色主题
  void setBlueTheme() {
    if (_currentTheme != AppThemeMode.blue) {
      _currentTheme = AppThemeMode.blue;
      notifyListeners();
    }
  }
  
  /// 切换主题（绿色和蓝色之间切换）
  void toggleTheme() {
    if (_currentTheme == AppThemeMode.green) {
      setBlueTheme();
    } else {
      setGreenTheme();
    }
  }
  
  /// 设置指定的主题
  void setTheme(AppThemeMode theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }
  
  /// 获取主题名称（用于UI显示）
  String getThemeName(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.green:
        return "绿色主题";
      case AppThemeMode.blue:
        return "蓝色主题";
    }
  }
  
  /// 获取当前主题名称
  String get currentThemeName => getThemeName(_currentTheme);
}