import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/arguments.dart';
import 'package:food_group_app/src/screens/label/edit_label_screen.dart';
import 'package:food_group_app/src/screens/loader_screen.dart';
import 'package:food_group_app/src/screens/person/edit_person_screen.dart';
import 'package:food_group_app/src/screens/rating/add_rating_screen.dart';
import 'package:food_group_app/src/screens/rating/show_ratings_screen.dart';
import 'package:food_group_app/src/screens/restaurant/add_restaurant_screen_new.dart';
import 'package:food_group_app/src/screens/restaurant/edit_restaurant_screen.dart';
import 'package:food_group_app/src/screens/restaurant/restaurants_screen.dart';

class AppRoutes {
  static const String editPerson = '/people/edit';
  static const String editLabel = '/labels/edit';

  static const String restaurants = '/restaurants';
  static const String editRestaurant = '/restaurants/edit';
  static const String addRestaurant = '/restaurants/add/new';
  static const String addRestaurantNew = '/restaurants/add/new/2';
  static const String addRestaurantName = '/restaurants/add/name';
  static const String addRestaurantAddress = '/restaurants/add/address';
  static const String addRestaurantDate = '/restaurants/add/date';
  static const String addRestaurantLabels = '/restaurants/add/labels';
  static const String addRestaurantPeople = '/restaurants/add/people';
  static const String addRestaurantOther = '/restaurants/add/other';

  static const String ratings = '/ratings';
  static const String addRating = '/ratings/add/new';

  static const String loader = '/loader';

  /// A map of routes that take no arguments
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.restaurants: (context) => const RestaurantScreen(),
    AppRoutes.ratings: (context) => const ShowRatingsScreen(),
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
      case AppRoutes.loader:
        return MaterialPageRoute<Person>(
          settings: settings,
          builder: (context) => LoaderScreen(
            initialFrame: settings.arguments as int,
          ),
        );
    }
    Route<dynamic>? route;
    route = _generateRestaurantRoutes(settings);
    route ??= _generateRatingRoutes(settings);
    return route;
  }

  /// A function to check if the route exists on one of the Restaurant pages.
  static Route<dynamic>? _generateRestaurantRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.editRestaurant:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddEditRestaurantScreen(
            restaurant: settings.arguments as Restaurant?,
          ),
        );
      case AppRoutes.addRestaurantNew:
        return MaterialPageRoute<Restaurant>(
          settings: settings,
          builder: (context) => AddRestaurantScreen2(
            restaurant: settings.arguments as Restaurant?,
          ),
        );
      default:
        return null;
    }
  }

  /// A function to check if the route exists on one of the Rating pages.
  static Route<dynamic>? _generateRatingRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.addRating:
        return MaterialPageRoute<Rating>(
          settings: settings,
          builder: (context) => AddRatingScreen(
            restaurant:
                (settings.arguments as RatingScreenArguments).restaurant,
            person: (settings.arguments as RatingScreenArguments).person,
            rating: (settings.arguments as RatingScreenArguments).rating,
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
