import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const QuestlyApp());
}

/// Root widget of the app. It is a StatelessWidget because it holds no
/// changing data - it only configures the theme and the first screen.
class QuestlyApp extends StatelessWidget {
  const QuestlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
