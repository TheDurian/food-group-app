import 'package:flutter/material.dart';

class AppThemes {
  static const Color schemeColor = Colors.brown;

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: schemeColor),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith();

  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}
