import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Color(0xFFFFD700),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFD700),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
    );
  }
}
