import 'package:food_group_app/src/models/db_types.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';

const String tableRestaurantPersons = 'restaurantPersonLink';
const String tableRestaurantPersonsCreate = '''
      CREATE TABLE $tableRestaurantPersons (
        ${RestaurantPersonFields.restaurantId} ${DbTypes.integerType},
        ${RestaurantPersonFields.personId} ${DbTypes.integerType},
        FOREIGN KEY (${RestaurantPersonFields.restaurantId})
          REFERENCES $tableRestaurants(${RestaurantFields.id}),
        FOREIGN KEY (${RestaurantPersonFields.personId})
          REFERENCES $tablePersons(${PersonFields.id}),
        PRIMARY KEY (
          ${RestaurantPersonFields.restaurantId},
          ${RestaurantPersonFields.personId}
        )
      )
    ''';

class RestaurantPersonFields {
  static final List<String> values = [
    restaurantId,
    personId,
  ];

  static const String restaurantId = 'restaurantId';
  static const String personId = 'personId';
}

class RestaurantPersonLink {
  final int restaurantId;
  final int personId;

  RestaurantPersonLink({
    required this.restaurantId,
    required this.personId,
  });

  RestaurantPersonLink copy({
    final int? restaurantId,
    final int? personId,
  }) =>
      RestaurantPersonLink(
        restaurantId: restaurantId ?? this.restaurantId,
        personId: personId ?? this.personId,
      );

  Map<String, Object?> toJson() => {
        RestaurantPersonFields.restaurantId: restaurantId,
        RestaurantPersonFields.personId: personId,
      };

  static RestaurantPersonLink fromJson(Map<String, Object?> json) =>
      RestaurantPersonLink(
        restaurantId: json[RestaurantPersonFields.restaurantId] as int,
        personId: json[RestaurantPersonFields.personId] as int,
      );
}
