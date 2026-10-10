import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FreshMartApp());
}

class FreshMartApp extends StatelessWidget {
  const FreshMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshMart',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      home: const SplashScreen(),
    );
  }
}