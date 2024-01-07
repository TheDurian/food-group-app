import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant_person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNull = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableRestaurants (
        ${RestaurantFields.id} $idType,
        ${RestaurantFields.name} $textType,
        ${RestaurantFields.isChain} $boolType,
        ${RestaurantFields.address} $textTypeNull,
        ${RestaurantFields.dateVisited} $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePersons (
        ${PersonFields.id} $idType,
        ${PersonFields.firstName} $textType,
        ${PersonFields.lastName} $textTypeNull
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableRestaurantPersons (
        ${RestaurantPersonFields.restaurantId} $integerType,
        ${RestaurantPersonFields.personId} $integerType,
        FOREIGN KEY (${RestaurantPersonFields.restaurantId})
          REFERENCES $tableRestaurants(${RestaurantFields.id}),
        FOREIGN KEY (${RestaurantPersonFields.personId})
          REFERENCES $tablePersons(${PersonFields.id}),
        PRIMARY KEY (
          ${RestaurantPersonFields.restaurantId},
          ${RestaurantPersonFields.personId}
        )
      )
    ''');
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
