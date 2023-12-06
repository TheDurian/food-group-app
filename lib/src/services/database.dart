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

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNull = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    // const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableRestaurants (
        ${RestaurantFields.id} $idType,
        ${RestaurantFields.name} $textType,
        ${RestaurantFields.isChain} $boolType,
        ${RestaurantFields.address} $textTypeNull,
        ${RestaurantFields.dateVisited} $textType
      )
    ''');
  }

  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    final db = await instance.database;
    final id = await db.insert(tableRestaurants, restaurant.toJson());
    return restaurant.copy(id: id);
  }

  Future<Restaurant> readRestaurant(int id) async {
    final db = await instance.database;
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

  Future<List<Restaurant>> readAllRestaurants() async {
    final db = await instance.database;
    final restaurants = await db.query(tableRestaurants);
    return restaurants.map((json) => Restaurant.fromJson(json)).toList();
  }

  Future<int> updateRestaurant(Restaurant restaurant) async {
    final db = await instance.database;
    return db.update(
      tableRestaurants,
      restaurant.toJson(),
      where: '${RestaurantFields.id} = ?',
      whereArgs: [restaurant.id],
    );
  }

  Future<int> deleteRestaurant(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableRestaurants,
      where: '${RestaurantFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
