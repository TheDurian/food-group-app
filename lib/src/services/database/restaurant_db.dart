import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/models/restaurant_label.dart';
import 'package:food_group_app/src/models/restaurant_person.dart';
import 'package:food_group_app/src/services/database/database.dart';

class RestaurantDatabase {
  static final DatabaseService _dbHelper = DatabaseService.instance;

  /// Creates a restaurant in the database.
  static Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    final db = await _dbHelper.database;
    final id = await db.insert(tableRestaurants, restaurant.toJson());

    for (final Person person in (restaurant.persons ?? [])) {
      final personLink = RestaurantPersonLink(
        restaurantId: id,
        personId: person.id!,
      );
      await db.insert(tableRestaurantPersons, personLink.toJson());
    }

    for (final Label label in (restaurant.labels ?? [])) {
      final labelLink = RestaurantLabelLink(
        restaurantId: id,
        labelId: label.id!,
      );
      await db.insert(tableRestaurantLabels, labelLink.toJson());
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
      final labels = await readLabelsForRestaurant(restaurant.id ?? 0);
      restaurant.persons?.addAll(persons);
      restaurant.labels?.addAll(labels);
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

    // Delete old persons / labels mappings.
    await db.delete(
      tableRestaurantPersons,
      where: '${RestaurantPersonFields.restaurantId} = ?',
      whereArgs: [restaurant.id],
    );
    await db.delete(
      tableRestaurantLabels,
      where: '${RestaurantLabelFields.restaurantId} = ?',
      whereArgs: [restaurant.id],
    );

    // Add new persons / labels mappings.
    for (final Person person in (restaurant.persons ?? [])) {
      final personLink = RestaurantPersonLink(
        restaurantId: restaurant.id!,
        personId: person.id!,
      );
      await db.insert(tableRestaurantPersons, personLink.toJson());
    }
    for (final Label label in (restaurant.labels ?? [])) {
      final labelLink = RestaurantLabelLink(
        restaurantId: restaurant.id!,
        labelId: label.id!,
      );
      await db.insert(tableRestaurantLabels, labelLink.toJson());
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
    await db.delete(
      tableRestaurantLabels,
      where: '${RestaurantLabelFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );
    await db.delete(
      tableRatings,
      where: '${RatingFields.restaurantId} = ?',
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

  /// Retrieves all labels for a given restaurant id.
  static Future<List<Label>> readLabelsForRestaurant(int restaurantId) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT $tableLabels.*
      FROM $tableLabels
      INNER JOIN $tableRestaurantLabels
        ON $tableLabels.${LabelFields.id} = $tableRestaurantLabels.${RestaurantLabelFields.labelId}
      WHERE $tableRestaurantLabels.${RestaurantLabelFields.restaurantId} = ?
    ''', [restaurantId]);

    return results.map((json) => Label.fromJson(json)).toList();
  }

  /// Retrieves all ratings for a given restaurant id.
  static Future<List<Rating>> readRatingsForRestaurant(int restaurantId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      tableRatings,
      where: '${RatingFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );

    return results.map((json) => Rating.fromJson(json)).toList();
  }
}
