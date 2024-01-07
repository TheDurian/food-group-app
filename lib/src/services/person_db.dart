import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/services/database.dart';

class PersonDatabase {
  static final DatabaseService _dbHelper = DatabaseService.instance;

  /// Creates a person in the database if the person does not already exist.
  static Future<Person> createPerson(Person person) async {
    final db = await _dbHelper.database;
    final id = await db.insert(tablePersons, person.toJson());
    return person.copy(id: id);
  }

  /// Finds a person given an id.
  static Future<Person> readPerson(int id) async {
    final db = await _dbHelper.database;
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
  static Future<List<Person>> readAllPersons() async {
    final db = await _dbHelper.database;
    final persons = await db.query(tablePersons);
    return persons.map((json) => Person.fromJson(json)).toList();
  }

  /// Updates a person in the database with a given record.
  static Future<Person> updatePerson(Person person) async {
    final db = await _dbHelper.database;
    await db.update(
      tablePersons,
      person.toJson(),
      where: '${PersonFields.id} = ?',
      whereArgs: [person.id],
    );
    return person;
  }

  /// Deletes a person in the database given an id.
  static Future<int> deletePerson(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tablePersons,
      where: '${PersonFields.id} = ?',
      whereArgs: [id],
    );
  }
}
