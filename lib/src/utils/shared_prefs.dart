import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  static const String keyIsDarkMode = "key_isDarkMode";

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  bool get isDarkMode => _sharedPrefs.getBool(keyIsDarkMode) ?? false;

  set isDarkMode(bool isDarkMode) =>
      _sharedPrefs.setBool(keyIsDarkMode, isDarkMode);
}
