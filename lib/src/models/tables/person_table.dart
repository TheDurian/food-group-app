import 'package:food_group_app/src/models/tables/db_types.dart';

class PersonFields {
  static final List<String> values = [
    id,
    firstName,
    lastName,
    dateAdded,
    dateModified,
  ];

  static const String id = '_id';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String dateAdded = 'dateAdded';
  static const String dateModified = 'dateModified';
}

const String tablePersons = 'persons';
const String tablePersonsCreate = '''
      CREATE TABLE $tablePersons (
        ${PersonFields.id} ${DbTypes.idType},
        ${PersonFields.firstName} ${DbTypes.textType},
        ${PersonFields.lastName} ${DbTypes.textTypeNull},
        ${PersonFields.dateAdded} ${DbTypes.textType},
        ${PersonFields.dateModified} ${DbTypes.textType}
      )
    ''';
