import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/tables/restaurant_table.dart';

class Restaurant {
  /// The id for a restaurant.
  final int? id;

  /// The Google Place Id for a restaurant.
  final String placeId;

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

  /// A list of ratings for this restaurant.
  final List<Rating>? ratings;

  /// The Google Photo Reference for a photo of this restaurant.
  final String photoReference;

  const Restaurant({
    this.id,
    required this.placeId,
    required this.name,
    this.isChain,
    this.address,
    required this.dateVisited,
    required this.dateAdded,
    required this.dateModified,
    this.persons,
    this.labels,
    this.ratings,
    required this.photoReference,
  });

  Restaurant copy({
    final int? id,
    final String? placeId,
    final String? name,
    final bool? isChain,
    final String? address,
    final DateTime? dateVisited,
    final DateTime? dateAdded,
    final DateTime? dateModified,
    final List<Person>? persons,
    final List<Label>? labels,
    final List<Rating>? ratings,
    final String? photoReference,
  }) =>
      Restaurant(
        id: id ?? this.id,
        placeId: placeId ?? this.placeId,
        name: name ?? this.name,
        isChain: isChain ?? this.isChain,
        address: address ?? this.address,
        dateVisited: dateVisited ?? this.dateVisited,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
        persons: persons ?? this.persons,
        labels: labels ?? this.labels,
        ratings: ratings ?? this.ratings,
        photoReference: photoReference ?? this.photoReference,
      );

  Map<String, Object?> toJson() => {
        RestaurantFields.id: id,
        RestaurantFields.placeId: placeId,
        RestaurantFields.name: name,
        RestaurantFields.isChain: isChain != null ? (isChain! ? 1 : 0) : null,
        RestaurantFields.address: address,
        RestaurantFields.dateVisited: dateVisited.toIso8601String(),
        RestaurantFields.dateAdded: dateAdded.toIso8601String(),
        RestaurantFields.dateModified: dateModified.toIso8601String(),
        RestaurantFields.photoReference: photoReference,
      };

  static Restaurant fromJson(Map<String, Object?> json) => Restaurant(
        id: json[RestaurantFields.id] as int?,
        placeId: json[RestaurantFields.placeId] as String,
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
        ratings: (json[RestaurantFields.ratings] as List<Rating>? ?? [])
            .map((ratingJson) =>
                Rating.fromJson(ratingJson as Map<String, Object?>))
            .toList(),
        photoReference: json[RestaurantFields.photoReference] as String,
      );

  @override
  String toString() => toJson().toString();

  /// Gets the average rating for all
  double getAverageRating() {
    if (ratings!.isEmpty) return 0;
    double totalRatings = ratings!
        .fold(0.0, (prevValue, rating) => prevValue + rating.totalRating());
    return totalRatings / (ratings!.length * 5);
  }
}
