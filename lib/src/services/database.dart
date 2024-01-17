import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant_label.dart';
import 'package:food_group_app/src/models/restaurant_person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  /// Retrieves the database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database.db');
    return _database!;
  }

  /// Initializes database instance.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Creates all tables that will be used.
  Future<void> _createDB(Database db, int version) async {
    await db.execute(tableRestaurantsCreate);
    await db.execute(tablePersonsCreate);
    await db.execute(tableRestaurantPersonsCreate);
    await db.execute(tableLabelsCreate);
    await db.execute(tableRestaurantLabelsCreate);
    await db.execute(tableRatingsCreate);
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
