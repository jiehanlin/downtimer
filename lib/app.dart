import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'models/timer_model.dart';
import 'widgets/led_display.dart';
import 'widgets/control_panel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '倒计时器',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF00FF41),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
            ],
          ),
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
        
        // 主要内容 - 使用 SingleChildScrollView 彻底防止溢出
        Expanded(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 40, // 减去标题栏高度
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // LED显示区域 - 固定高度
                    SizedBox(
                      height: 150,
                      child: _buildLEDDisplay(timerModel),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 控制面板 - 让它自然占用所需高度
                    const ControlPanel(),
                    
                    // 底部留出空间
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
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
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(bottom: BorderSide(color: const Color(0xFF00FF41).withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                windowManager.startDragging();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  '倒计时器',
                  style: TextStyle(
                    color: Color(0xFF00FF41),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // 窗口控制按钮
          Row(
            children: [
              // 只在正常模式下显示最小化按钮
              Consumer<TimerModel>(
                builder: (context, timerModel, child) {
                  if (timerModel.displayMode == 0) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            timerModel.minimizeWindow();
                          },
                          icon: const Icon(Icons.minimize, size: 16, color: Color(0xFF00FF41)),
                          tooltip: '最小化',
                        ),
                        IconButton(
                          onPressed: () {
                            timerModel.setDisplayMode(2);
                          },
                          icon: const Icon(Icons.fullscreen_exit, size: 16, color: Color(0xFF00FF41)),
                          tooltip: '超小化',
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              IconButton(
                onPressed: () => windowManager.close(),
                icon: const Icon(Icons.close, size: 16, color: Color(0xFFFF4444)),
                tooltip: '关闭',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLEDDisplay(TimerModel timerModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据窗口大小计算字体大小
        final maxWidth = constraints.maxWidth;
        final fontSize = (maxWidth * 0.25).clamp(24.0, 120.0);
        
        return LEDDisplay(
          timeString: timerModel.formattedTime,
          fontSize: fontSize,
          onDoubleTap: () {
            Provider.of<TimerModel>(context, listen: false).restoreWindow();
          },
        );
      },
    );
  }

  Widget _buildCompactLEDDisplay(TimerModel timerModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 最小化模式下也增大字体比例
        final maxWidth = constraints.maxWidth;
        final fontSize = (maxWidth * 0.22).clamp(28.0, 100.0); // 增大最小化模式的字体
        
        return LEDDisplay(
          timeString: timerModel.formattedTime,
          fontSize: fontSize,
          color: const Color(0xFF00FF41),
          backgroundColor: const Color(0xFF0A0A0A),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // 增加垂直padding确保上下对称
          onDoubleTap: () {
            Provider.of<TimerModel>(context, listen: false).restoreWindow();
          },
        );
      },
    );
  }

  Widget _buildUltraCompactLEDDisplay(TimerModel timerModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 超小模式下调整字体大小以适应280px宽度
        final maxWidth = constraints.maxWidth;
        final fontSize = (maxWidth * 0.18).clamp(28.0, 80.0); // 减小字体大小避免溢出
        
        return LEDDisplay(
          timeString: timerModel.formattedTime,
          fontSize: fontSize,
          color: const Color(0xFF00FF41),
          backgroundColor: const Color(0xFF0A0A0A),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // 更小的水平padding
          onDoubleTap: () {
            Provider.of<TimerModel>(context, listen: false).restoreWindow();
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