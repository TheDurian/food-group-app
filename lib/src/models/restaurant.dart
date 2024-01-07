// TODO V2 delivered/delivery details

// TODO add back later since this is a bit more complex
// import 'package:food_group_app/src/models/person.dart';

import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';

const String tableRestaurants = 'restaurants';

class RestaurantFields {
  static final List<String> values = [
    id,
    name,
    isChain,
    address,
    dateVisited,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String isChain = 'isChain';
  static const String address = 'address';
  static const String dateVisited = 'dateVisited';
  static const String persons = 'persons';
  static const String labels = 'labels';
}

class Restaurant {
  /// The id for a restaurant.
  final int? id;

  /// The display name for a restaurant.
  final String name;

  /// Whether this restaurant is a chain or not.
  final bool isChain;

  /// The address for a restaurant.
  final String? address;

  /// The date this restaurant was visited.
  final DateTime dateVisited;

  /// A list of people who were a part of the outing to this restaurant.
  final List<Person> persons;

  /// A list of labels representing this restaurant.
  final List<Label> labels;

  Restaurant({
    this.id,
    required this.name,
    required this.isChain,
    this.address,
    required this.dateVisited,
    required this.persons,
    required this.labels,
  });

  Restaurant copy({
    final int? id,
    final String? name,
    final bool? isChain,
    final String? address,
    final DateTime? dateVisited,
    final List<Person>? persons,
    final List<Label>? labels,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        isChain: isChain ?? this.isChain,
        address: address ?? this.address,
        dateVisited: dateVisited ?? this.dateVisited,
        persons: persons ?? this.persons,
        labels: labels ?? this.labels,
      );

  Map<String, Object?> toJson() => {
        RestaurantFields.id: id,
        RestaurantFields.name: name,
        RestaurantFields.isChain: isChain ? 1 : 0,
        RestaurantFields.address: address,
        RestaurantFields.dateVisited: dateVisited.toIso8601String(),
      };

  static Restaurant fromJson(Map<String, Object?> json) => Restaurant(
        id: json[RestaurantFields.id] as int?,
        name: json[RestaurantFields.name] as String,
        isChain: json[RestaurantFields.isChain] == 1,
        address: json[RestaurantFields.address] as String?,
        dateVisited:
            DateTime.parse(json[RestaurantFields.dateVisited] as String),
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
