import 'package:flutter/material.dart';
import 'package:rehearse_app/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return replaceFirst(this[0], this[0].toUpperCase());
  }
}
