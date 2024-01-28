import 'package:flutter/material.dart';
import 'package:food_group_app/src/utils/shared_prefs.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static Color schemeColor = Colors.orange;

  /// Style to use for text along the top of a view.
  static TextStyle? upperTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          );

  /// Style to use for text along the center of a view.
  static TextStyle? centerTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          );

  /// Style to use for text along the bottom of a view.
  static TextStyle? subTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontStyle: FontStyle.italic,
          );

  /// Function to retrieve theme based off brightness.
  static ThemeData getCurrentTheme(bool isDark) {
    return ThemeData(
      colorSchemeSeed: schemeColor,
      textTheme: GoogleFonts.robotoTextTheme(),
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}

class AppTheme extends ChangeNotifier {
  static Color schemeColor = Colors.orange;
  static bool _isDark = false;

  AppTheme() {
    _isDark = SharedPrefs().isDarkMode;
  }

  /// Function to retrieve theme based off brightness.
  ThemeMode getCurrentThemeMode() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Function to retrieve theme based off brightness.
  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      colorSchemeSeed: schemeColor,
      textTheme: GoogleFonts.robotoTextTheme(),
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }

  void switchTheme() {
    _isDark = !_isDark;
    SharedPrefs().isDarkMode = _isDark;
    notifyListeners();
  }
}
