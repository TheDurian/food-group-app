const String tablePersons = 'persons';

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

class Person {
  /// The id for a person.
  final int? id;

  /// The first name for a person.
  final String firstName;

  /// The last name for a person.
  final String? lastName;

  /// The date this person was added to the database.
  final DateTime? dateAdded;

  /// The date this person was last modified.
  final DateTime? dateModified;

  Person({
    this.id,
    required this.firstName,
    this.lastName,
    this.dateAdded,
    this.dateModified,
  });

  Person copy({
    final int? id,
    final String? firstName,
    final String? lastName,
    final DateTime? dateAdded,
    final DateTime? dateModified,
  }) =>
      Person(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
      );

  Map<String, Object?> toJson() => {
        PersonFields.id: id,
        PersonFields.firstName: firstName,
        PersonFields.lastName: lastName,
        PersonFields.dateAdded: dateAdded?.toIso8601String(),
        PersonFields.dateModified: dateModified?.toIso8601String(),
      };

  static Person fromJson(Map<String, Object?> json) => Person(
        id: json[PersonFields.id] as int?,
        firstName: json[PersonFields.firstName] as String,
        lastName: json[PersonFields.lastName] as String?,
        dateAdded: DateTime.parse(json[PersonFields.dateAdded] as String),
        dateModified: DateTime.parse(json[PersonFields.dateModified] as String),
      );

  /// Generates the full name of a person.
  String fullName() => "$firstName $lastName";
  static String fullNameFromPerson(Person person) =>
      "${person.firstName} ${person.lastName}";

  @override
  bool operator ==(Object other) => other is Person && other.id == id;

  @override
  int get hashCode => id ?? 0;
}
