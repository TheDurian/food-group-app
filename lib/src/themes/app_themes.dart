import 'package:flutter/material.dart';

class AppThemes {
  // Colors
  // static const Color primaryColor = Colors.blue;
  // static const Color accentColor = Colors.orange;
  // static const Color background = Color(0xFFF5F5F5);
  // static const Color text = Color(0xFF333333);
  static const Color schemeColor = Color.fromRGBO(138, 110, 80, 1);

  // Theme Data
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: schemeColor),
    useMaterial3: true,
    // TODO add any other theme configurations
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      // TODO add configuration for dark theme
      );

  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}
