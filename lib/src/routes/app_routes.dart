import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/screens/label/edit_label_screen.dart';
import 'package:food_group_app/src/screens/person/edit_person_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant/address_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant/date_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant/other_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant/name_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant/labels_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant/people_screen.dart';
import 'package:food_group_app/src/screens/restaurant/edit_restaurant_screen.dart';
import 'package:food_group_app/src/screens/restaurant/restaurants_screen.dart';

class AppRoutes {
  static const String editPerson = '/people/edit';
  static const String editLabel = '/labels/edit';

  static const String restaurants = '/restaurants';
  static const String editRestaurant = '/restaurants/edit';
  static const String addRestaurant = '/restaurants/add/new';
  static const String addRestaurantName = '/restaurants/add/name';
  static const String addRestaurantAddress = '/restaurants/add/address';
  static const String addRestaurantDate = '/restaurants/add/date';
  static const String addRestaurantLabels = '/restaurants/add/labels';
  static const String addRestaurantPeople = '/restaurants/add/people';
  static const String addRestaurantOther = '/restaurants/add/other';

  /// A map of routes that take no arguments
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.restaurants: (context) => const RestaurantScreen(),
  };

  /// A mapping of available routes with logic/arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.editLabel:
        return MaterialPageRoute<Label>(
          settings: settings,
          builder: (context) => AddEditLabelScreen(
            label: settings.arguments as Label?,
          ),
        );
      case AppRoutes.editPerson:
        return MaterialPageRoute<Person>(
          settings: settings,
          builder: (context) => AddEditPersonScreen(
            person: settings.arguments as Person?,
          ),
        );
    }
    Route<dynamic>? route = _generateRestaurantRoutes(settings);
    return route;
  }

  /// A function to check if the route exists on one of the Restaurant pages.
  static Route<dynamic>? _generateRestaurantRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.addRestaurantName:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantNameScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );
      case AppRoutes.addRestaurantAddress:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantAddressScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );
      case AppRoutes.addRestaurantDate:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantDateScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );
      case AppRoutes.addRestaurantLabels:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantLabelsScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );
      case AppRoutes.addRestaurantPeople:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantPeopleScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );
      case AppRoutes.addRestaurantOther:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantOtherScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );
      case AppRoutes.editRestaurant:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
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
