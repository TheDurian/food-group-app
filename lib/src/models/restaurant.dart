import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/db_types.dart';

const String tableRestaurants = 'restaurants';
const String tableRestaurantsCreate = '''
      CREATE TABLE $tableRestaurants (
        ${RestaurantFields.id} ${DbTypes.idType},
        ${RestaurantFields.name} ${DbTypes.textTypeNull},
        ${RestaurantFields.isChain} ${DbTypes.boolTypeNull},
        ${RestaurantFields.address} ${DbTypes.textTypeNull},
        ${RestaurantFields.dateVisited} ${DbTypes.textTypeNull},
        ${RestaurantFields.dateAdded} ${DbTypes.textType},
        ${RestaurantFields.dateModified} ${DbTypes.textType}
      )
    ''';

class RestaurantFields {
  static final List<String> values = [
    id,
    name,
    isChain,
    address,
    dateVisited,
    dateAdded,
    dateModified,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String isChain = 'isChain';
  static const String address = 'address';
  static const String dateVisited = 'dateVisited';
  static const String persons = 'persons';
  static const String labels = 'labels';
  static const String dateAdded = 'dateAdded';
  static const String dateModified = 'dateModified';
}

class Restaurant {
  /// The id for a restaurant.
  final int? id;

  /// The display name for a restaurant.
  final String name;

  /// Whether this restaurant is a chain or not.
  final bool? isChain;

  /// The address for a restaurant.
  final String? address;

  /// The date this restaurant was visited.
  final DateTime dateVisited;

  /// The date this restaurant was added to the database.
  final DateTime dateAdded;

  /// The date this restaurant was last modified.
  final DateTime dateModified;

  /// A list of people who were a part of the outing to this restaurant.
  final List<Person>? persons;

  /// A list of labels representing this restaurant.
  final List<Label>? labels;

  const Restaurant({
    this.id,
    required this.name,
    this.isChain,
    this.address,
    required this.dateVisited,
    required this.dateAdded,
    required this.dateModified,
    this.persons,
    this.labels,
  });

  Restaurant copy({
    final int? id,
    final String? name,
    final bool? isChain,
    final String? address,
    final DateTime? dateVisited,
    final DateTime? dateAdded,
    final DateTime? dateModified,
    final List<Person>? persons,
    final List<Label>? labels,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        isChain: isChain ?? this.isChain,
        address: address ?? this.address,
        dateVisited: dateVisited ?? this.dateVisited,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
        persons: persons ?? this.persons,
        labels: labels ?? this.labels,
      );

  Map<String, Object?> toJson() => {
        RestaurantFields.id: id,
        RestaurantFields.name: name,
        RestaurantFields.isChain: isChain != null ? (isChain! ? 1 : 0) : null,
        RestaurantFields.address: address,
        RestaurantFields.dateVisited: dateVisited.toIso8601String(),
        RestaurantFields.dateAdded: dateAdded.toIso8601String(),
        RestaurantFields.dateModified: dateModified.toIso8601String(),
      };

  static Restaurant fromJson(Map<String, Object?> json) => Restaurant(
        id: json[RestaurantFields.id] as int?,
        name: json[RestaurantFields.name] as String,
        isChain: json[RestaurantFields.isChain] != null
            ? json[RestaurantFields.isChain] == 1
            : null,
        address: json[RestaurantFields.address] as String?,
        dateVisited:
            DateTime.parse(json[RestaurantFields.dateVisited] as String),
        dateAdded: DateTime.parse(json[RestaurantFields.dateAdded] as String),
        dateModified:
            DateTime.parse(json[RestaurantFields.dateModified] as String),
        persons: (json[RestaurantFields.persons] as List<Person>? ?? [])
            .map((personJson) =>
                Person.fromJson(personJson as Map<String, Object?>))
            .toList(),
        labels: (json[RestaurantFields.labels] as List<Label>? ?? [])
            .map((labelJson) =>
                Label.fromJson(labelJson as Map<String, Object?>))
            .toList(),
      );
}
