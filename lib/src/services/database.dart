import 'package:food_group_app/src/models/person.dart';
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

    await db.execute('''
      CREATE TABLE $tablePersons (
        ${PersonFields.id} $idType,
        ${PersonFields.firstName} $textType,
        ${PersonFields.lastName} $textTypeNull
      )
    ''');
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  /*************
  * RESTAURANT *
  *************/

  /// Creates a restaurant in the database.
  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    final db = await instance.database;
    final id = await db.insert(tableRestaurants, restaurant.toJson());
    return restaurant.copy(id: id);
  }

  /// Finds a restaurant given an id.
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

  /// Retrieves all restaurants from the database.
  Future<List<Restaurant>> readAllRestaurants() async {
    final db = await instance.database;
    final restaurants = await db.query(tableRestaurants);
    return restaurants.map((json) => Restaurant.fromJson(json)).toList();
  }

  /// Updates a restaurant in the database with a given record.
  Future<int> updateRestaurant(Restaurant restaurant) async {
    final db = await instance.database;
    return db.update(
      tableRestaurants,
      restaurant.toJson(),
      where: '${RestaurantFields.id} = ?',
      whereArgs: [restaurant.id],
    );
  }

  /// Deletes a restaurant in the database given an id.
  Future<int> deleteRestaurant(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableRestaurants,
      where: '${RestaurantFields.id} = ?',
      whereArgs: [id],
    );
  }

  /*********
  * PERSON *
  *********/

  /// Creates a person in the database if the person does not already exist.
  ///
  /// The id of an existing Person will be returned if the firstName
  /// and lastName matches to an already created person. This is to
  /// avoid creating duplicate people. If the first/last name is not found,
  /// a new Person will be created.
  Future<Person> createPerson(Person person) async {
    final db = await instance.database;
    final id = await db.insert(tablePersons, person.toJson());
    return person.copy(id: id);
  }

  /// Finds a person given an id.
  Future<Person> readPerson(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tablePersons,
      columns: PersonFields.values,
      where: '${PersonFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Person.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  /// Retrieves all people from the database.
  Future<List<Person>> readAllPersons() async {
    final db = await instance.database;
    final persons = await db.query(tablePersons);
    return persons.map((json) => Person.fromJson(json)).toList();
  }

  /// Updates a person in the database with a given record.
  Future<Person> updatePerson(Person person) async {
    final db = await instance.database;
    await db.update(
      tablePersons,
      person.toJson(),
      where: '${PersonFields.id} = ?',
      whereArgs: [person.id],
    );
    return person;
  }

  /// Deletes a person in the database given an id.
  Future<int> deletePerson(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePersons,
      where: '${PersonFields.id} = ?',
      whereArgs: [id],
    );
  }
}
