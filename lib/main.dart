import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'models/timer_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 配置窗口管理器
  await windowManager.ensureInitialized();
  
  // 设置窗口选项
  WindowOptions windowOptions = const WindowOptions(
    size: Size(450, 370),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
    minimumSize: Size(200, 100),
    maximumSize: Size(800, 600),
    windowButtonVisibility: false,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerModel(),
      child: const MyApp(),
    ),
  );
}