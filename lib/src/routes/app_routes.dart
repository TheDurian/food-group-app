import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/screens/label/edit_label_screen.dart';
import 'package:food_group_app/src/screens/person/edit_person_screen.dart';
import 'package:food_group_app/src/screens/restaurant/edit_restaurant_screen.dart';
import 'package:food_group_app/src/screens/restaurant/restaurants_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String restaurants = '/restaurants';
  static const String editRestaurant = '/editRestaurant';
  static const String editPerson = '/editPerson';
  static const String editLabel = '/editLabel';

  /// A map of routes that take no arguments
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.home: (context) => const RestaurantScreen(),
    AppRoutes.restaurants: (context) => const RestaurantScreen(),
  };

  /// A mapping of available routes with logic/arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.editLabel:
        return MaterialPageRoute<Label>(
          builder: (context) => AddEditLabelScreen(
            label: settings.arguments as Label?,
          ),
        );
      case AppRoutes.editPerson:
        return MaterialPageRoute<Person>(
          builder: (context) => AddEditPersonScreen(
            person: settings.arguments as Person?,
          ),
        );
      case AppRoutes.editRestaurant:
        return MaterialPageRoute<Restaurant>(
          builder: (context) => AddEditRestaurantScreen(
            restaurant: settings.arguments as Restaurant?,
          ),
        );
      default:
        return null;
    }
  }

  /// Function to handle if unknown route is provided.
  static Route<dynamic>? onUnknownRoute(context) => MaterialPageRoute(
        builder: (context) => const RestaurantScreen(),
      );
}
