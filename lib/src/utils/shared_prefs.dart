import 'package:food_group_app/src/models/sorts/person_sort.dart';
import 'package:food_group_app/src/models/sorts/restaurant_sort.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  /// Current Dark Mode.
  static const String keyIsDarkMode = "key_isDarkMode";
  bool get isDarkMode => _sharedPrefs.getBool(keyIsDarkMode) ?? false;
  set isDarkMode(bool isDarkMode) =>
      _sharedPrefs.setBool(keyIsDarkMode, isDarkMode);

  /// Current Restaurant Sorting method.
  static const String keyRestaurantSort = 'key_restaurantSort';
  RestaurantSort get restaurantSort => RestaurantSort.searchByName(
        _sharedPrefs.getString(keyRestaurantSort) ??
            RestaurantSort.newlyVisited.name,
      );
  set restaurantSort(RestaurantSort sort) =>
      _sharedPrefs.setString(keyRestaurantSort, sort.name);

  /// Current Person Sorting method.
  static const String keyPersonSort = 'key_personSort';
  PersonSort get personSort => PersonSort.searchByName(
        _sharedPrefs.getString(keyPersonSort) ?? PersonSort.alphabetical.name,
      );
  set personSort(PersonSort sort) =>
      _sharedPrefs.setString(keyPersonSort, sort.name);
}
