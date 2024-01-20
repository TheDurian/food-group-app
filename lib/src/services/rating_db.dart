import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/services/database.dart';

class RatingDatabase {
  static final DatabaseService _dbHelper = DatabaseService.instance;

  /// Creates a rating in the database if the rating does not already exist.
  static Future<Rating> createRating(Rating rating) async {
    final db = await _dbHelper.database;
    await db.insert(tableRatings, rating.toJson());
    return rating;
  }

  /// Finds a rating given an id.
  static Future<Rating?> readRating(int restaurantId, int personId,
      {bool raiseOnError = true}) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      tableRatings,
      columns: RatingFields.values,
      where: '${RatingFields.restaurantId} = ? '
          'AND ${RatingFields.personId} = ?',
      whereArgs: [restaurantId, personId],
    );

    if (maps.isNotEmpty) {
      return Rating.fromJson(maps.first);
    } else if (raiseOnError) {
      throw Exception(
          'ID combo Restaurant:$restaurantId Person:$personId not found');
    } else {
      return null;
    }
  }

  /// Retrieves all people from the database.
  static Future<List<Rating>> readAllRatings() async {
    final db = await _dbHelper.database;
    final ratings = await db.query(tableRatings);
    return ratings.map((json) => Rating.fromJson(json)).toList();
  }

  /// Updates a rating in the database with a given record.
  static Future<Rating> updateRating(Rating rating) async {
    final db = await _dbHelper.database;
    await db.update(
      tableRatings,
      rating.toJson(),
      where: '${RatingFields.restaurantId} = ? '
          'AND ${RatingFields.personId} = ?',
      whereArgs: [rating.restaurantId, rating.personId],
    );
    return rating;
  }

  /// Deletes a rating in the database given an id.
  static Future<int> deleteRating(int restaurantId, int personId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableRatings,
      where: '${RatingFields.restaurantId} = ? '
          'AND ${RatingFields.personId} = ?',
      whereArgs: [restaurantId, personId],
    );
  }
}
