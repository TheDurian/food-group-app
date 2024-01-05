const String tablePersons = 'persons';

class PersonFields {
  static final List<String> values = [
    id,
    firstName,
    lastName,
  ];

  static const String id = '_id';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
}

class Person {
  final int? id;
  final String firstName;
  final String? lastName;

  Person({
    this.id,
    required this.firstName,
    this.lastName,
  });

  Person copy({
    final int? id,
    final String? firstName,
    final String? lastName,
  }) =>
      Person(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  Map<String, Object?> toJson() => {
        PersonFields.id: id,
        PersonFields.firstName: firstName,
        PersonFields.lastName: lastName,
      };

  static Person fromJson(Map<String, Object?> json) => Person(
        id: json[PersonFields.id] as int?,
        firstName: json[PersonFields.firstName] as String,
        lastName: json[PersonFields.lastName] as String?,
      );

  /// Generates the full name of a person.
  String fullName() => "$firstName $lastName";

  @override
  bool operator ==(Object other) => other is Person && other.id == id;

  @override
  int get hashCode => id ?? 0;
}
