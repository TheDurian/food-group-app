import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/models/restaurant_person.dart';
import 'package:food_group_app/src/services/database.dart';

class RestaurantDatabase {
  static final DatabaseService _dbHelper = DatabaseService.instance;

  /// Creates a restaurant in the database.
  static Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    final db = await _dbHelper.database;
    final id = await db.insert(tableRestaurants, restaurant.toJson());

    for (final person in restaurant.persons) {
      final personLink = RestaurantPersonLink(
        restaurantId: id,
        personId: person.id!,
      );
      await db.insert(tableRestaurantPersons, personLink.toJson());
    }
    return restaurant.copy(id: id);
  }

  /// Finds a restaurant given an id.
  static Future<Restaurant> readRestaurant(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      tableRestaurants,
      columns: RestaurantFields.values,
      where: '${RestaurantFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Restaurant.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  /// Retrieves all restaurants from the database.
  static Future<List<Restaurant>> readAllRestaurants() async {
    final db = await _dbHelper.database;
    final restaurants = await db.query(tableRestaurants);

    final List<Restaurant> restaurantsList = [];
    for (final json in restaurants) {
      final restaurant = Restaurant.fromJson(json);
      final persons = await readPeopleForRestaurant(restaurant.id ?? 0);
      restaurant.persons.addAll(persons);
      restaurantsList.add(restaurant);
    }

    return restaurantsList;
  }

  /// Updates a restaurant in the database with a given record.
  static Future<int> updateRestaurant(Restaurant restaurant) async {
    final db = await _dbHelper.database;
    final restaurantId = await db.update(
      tableRestaurants,
      restaurant.toJson(),
      where: '${RestaurantFields.id} = ?',
      whereArgs: [restaurant.id],
    );
    await db.delete(
      tableRestaurantPersons,
      where: '${RestaurantPersonFields.restaurantId} = ?',
      whereArgs: [restaurant.id],
    );
    for (final person in restaurant.persons) {
      final personLink = RestaurantPersonLink(
        restaurantId: restaurant.id!,
        personId: person.id!,
      );
      await db.insert(tableRestaurantPersons, personLink.toJson());
    }

    return restaurantId;
  }

  /// Deletes a restaurant in the database given an id.
  ///
  /// This will also delete any restaurant-person links.
  static Future<void> deleteRestaurant(int restaurantId) async {
    final db = await _dbHelper.database;
    await db.delete(
      tableRestaurants,
      where: '${RestaurantFields.id} = ?',
      whereArgs: [restaurantId],
    );
    await db.delete(
      tableRestaurantPersons,
      where: '${RestaurantPersonFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );
  }

  /// Retrieves all people for a given restaurant id.
  static Future<List<Person>> readPeopleForRestaurant(int restaurantId) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT $tablePersons.*
      FROM $tablePersons
      INNER JOIN $tableRestaurantPersons
        ON $tablePersons.${PersonFields.id} = $tableRestaurantPersons.${RestaurantPersonFields.personId}
      WHERE $tableRestaurantPersons.${RestaurantPersonFields.restaurantId} = ?
    ''', [restaurantId]);

    return results.map((json) => Person.fromJson(json)).toList();
  }
}
