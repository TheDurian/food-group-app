import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNull = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const integerTypeNull = 'INTEGER';

    // Create Restaurant table
    await db.execute('''
      CREATE TABLE $tableRestaurants (
        ${RestaurantFields.id} $idType,
        ${RestaurantFields.name} $textType,
        ${RestaurantFields.isChain} $boolType,
        ${RestaurantFields.address} $textTypeNull,
        ${RestaurantFields.dateVisited} $textType,
        ${RestaurantFields.dateAdded} $textType,
        ${RestaurantFields.dateModified} $textType
      )
    ''');

    // Create Person table
    await db.execute('''
      CREATE TABLE $tablePersons (
        ${PersonFields.id} $idType,
        ${PersonFields.firstName} $textType,
        ${PersonFields.lastName} $textTypeNull,
        ${PersonFields.dateAdded} $textType,
        ${PersonFields.dateModified} $textType
      )
    ''');

    // Create Restaurant->Persons link table
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

    // Create Label table
    await db.execute('''
      CREATE TABLE $tableLabels (
        ${LabelFields.id} $idType,
        ${LabelFields.label} $textType,
        ${LabelFields.dateAdded} $textType,
        ${LabelFields.color} $integerTypeNull,
        ${LabelFields.dateModified} $textType
      )
    ''');

    // Create Restaurant->Labels link table
    await db.execute('''
      CREATE TABLE $tableRestaurantLabels (
        ${RestaurantLabelFields.restaurantId} $integerType,
        ${RestaurantLabelFields.labelId} $integerType,
        FOREIGN KEY (${RestaurantLabelFields.restaurantId})
          REFERENCES $tableRestaurants(${RestaurantFields.id}),
        FOREIGN KEY (${RestaurantLabelFields.labelId})
          REFERENCES $tableLabels(${LabelFields.id}),
        PRIMARY KEY (
          ${RestaurantLabelFields.restaurantId},
          ${RestaurantLabelFields.labelId}
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
