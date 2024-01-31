import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/services/database/database.dart';

class LabelDatabase {
  static final DatabaseService _dbHelper = DatabaseService.instance;

  /// Creates a label in the database if the label does not already exist.
  static Future<Label> createLabel(Label label) async {
    final db = await _dbHelper.database;
    final id = await db.insert(tableLabels, label.toJson());
    return label.copy(id: id);
  }

  /// Finds a label given an id.
  static Future<Label> readLabel(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      tableLabels,
      columns: LabelFields.values,
      where: '${LabelFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Label.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  /// Retrieves all people from the database.
  static Future<List<Label>> readAllLabels() async {
    final db = await _dbHelper.database;
    final labels = await db.query(tableLabels);
    return labels.map((json) => Label.fromJson(json)).toList();
  }

  /// Updates a label in the database with a given record.
  static Future<Label> updateLabel(Label label) async {
    final db = await _dbHelper.database;
    await db.update(
      tableLabels,
      label.toJson(),
      where: '${LabelFields.id} = ?',
      whereArgs: [label.id],
    );
    return label;
  }

  /// Deletes a label in the database given an id.
  static Future<int> deleteLabel(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableLabels,
      where: '${LabelFields.id} = ?',
      whereArgs: [id],
    );
  }
}
