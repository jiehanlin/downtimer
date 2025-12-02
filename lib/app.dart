import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'models/timer_model.dart';
import 'widgets/led_display.dart';
import 'widgets/control_panel.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: '倒计时器',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppTheme.darkBackground,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: AppTheme.getPrimaryColor(themeManager),
              ),
              textTheme: const TextTheme(
                // 所有文本样式都会使用这个字体
                bodyLarge: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                bodyMedium: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                displayLarge: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                displayMedium: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                headlineMedium: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                headlineSmall: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                titleLarge: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                titleMedium: TextStyle(fontFamily: AppTheme.chineseFontFamily),
                // 可以根据需要添加更多样式
              ),
            ),
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: _buildView(timerModel),
      ),
    );
  }

  Widget _buildView(TimerModel timerModel) {
    switch (timerModel.displayMode) {
      case 0: // 正常模式
        return _buildNormalView(timerModel);
      case 1: // 最小化模式
        return _buildMinimizedView(timerModel);
      case 2: // 超小模式
        return _buildUltraMinimizedView(timerModel);
      default:
        return _buildNormalView(timerModel);
    }
  }

  Widget _buildNormalView(TimerModel timerModel) {
    return Column(
      children: [
        // 标题栏
        _buildTitleBar(),
        
        // 主要内容区域
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
            // 确保有足够的最小空间避免溢出
            // LED(150) + 间距(12) + 控制面板(78) = 240
              
              return Column(
                children: [
                  // LED显示区域 - 固定高度，响应式字体
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    child: _buildLEDDisplay(timerModel),
                  ),
                  
                  const SizedBox(height: 1),
                  
                  // 控制面板 - 使用最小高度确保不溢出，并向下对齐
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 78, // 控制面板的最小高度
                        ),
                        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: const ControlPanel(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMinimizedView(TimerModel timerModel) {
    return GestureDetector(
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: SizedBox(
        height: 140, // 增加LED显示区域高度，为标题栏留40px
        child: Center(
          child: _buildCompactLEDDisplay(timerModel),
        ),
      ),
    );
  }

  Widget _buildUltraMinimizedView(TimerModel timerModel) {
    return GestureDetector(
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: SizedBox(
        height: 65, // 超小模式高度
        child: Center(
          child: _buildUltraCompactLEDDisplay(timerModel),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Consumer2<TimerModel, ThemeManager>(
      builder: (context, timerModel, themeManager, child) {
        return GestureDetector(
          onPanStart: (details) {
            windowManager.startDragging();
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.mediumBackground,
              border: Border(bottom: BorderSide(color: AppTheme.borderColorWithOpacity(themeManager, 0.2))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      '倒计时器',
                      style: AppTheme.titleStyle(themeManager),
                    ),
                  ),
                ),
                
                // 窗口控制按钮 - 需要阻止拖动事件冒泡
                Row(
                  children: [
                    // 只在正常模式下显示最小化按钮
                    if (timerModel.displayMode == 0) ...[
                      GestureDetector(
                        onTap: () {
                          timerModel.minimizeWindow();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.minimize, size: 16, color: AppTheme.getPrimaryColor(themeManager)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          timerModel.setDisplayMode(2);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.fullscreen_exit, size: 16, color: AppTheme.getPrimaryColor(themeManager)),
                        ),
                      ),
                    ],
                    GestureDetector(
                      onTap: () => windowManager.close(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.close, size: 16, color: AppTheme.warningColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLEDDisplay(TimerModel timerModel) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // 根据窗口大小计算字体大小
            final maxWidth = constraints.maxWidth;
            final fontSize = (maxWidth * 0.26).clamp(24.0, 120.0);
            
            return LEDDisplay(
              timeString: timerModel.formattedTime,
              fontSize: fontSize,
              backgroundColor: AppTheme.darkBackground,
              padding: const EdgeInsets.all(16),
              onDoubleTap: () {
                Provider.of<TimerModel>(context, listen: false).restoreWindow();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCompactLEDDisplay(TimerModel timerModel) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // 最小化模式下也增大字体比例
            final maxWidth = constraints.maxWidth;
            final fontSize = (maxWidth * 0.26).clamp(24.0, 120.0); // 增大最小化模式的字体
            
            return LEDDisplay(
              timeString: timerModel.formattedTime,
              fontSize: fontSize,
              backgroundColor: AppTheme.darkBackground,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // 增加垂直padding确保上下对称
              onDoubleTap: () {
                Provider.of<TimerModel>(context, listen: false).restoreWindow();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUltraCompactLEDDisplay(TimerModel timerModel) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // 超小模式下调整字体大小以适应280px宽度
            final maxWidth = constraints.maxWidth;
            final fontSize = (maxWidth * 0.25).clamp(28.0, 80.0); // 减小字体大小避免溢出
            
            return LEDDisplay(
              timeString: timerModel.formattedTime,
              fontSize: fontSize,
              backgroundColor: AppTheme.darkBackground,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // 更小的水平padding
              onDoubleTap: () {
                Provider.of<TimerModel>(context, listen: false).restoreWindow();
              },
            );
          },
        );
      },
    );
  }

  // 窗口事件处理
  @override
  void onWindowResize() {
    setState(() {});
  }

  @override
  void onWindowMove() {
    setState(() {});
  }
}