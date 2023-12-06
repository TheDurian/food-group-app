// TODO V2 delivered/delivery details

// TODO add back later since this is a bit more complex
// import 'package:food_group_app/src/models/person.dart';

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
}

class Restaurant {
  final int? id;
  final String name;
  final bool isChain;
  final String? address;
  final DateTime dateVisited;

  // TODO add back later since this is a bit more complex
  // final List<String>? labels;
  // final List<Person>? peopleInvolved;

  Restaurant({
    this.id,
    required this.name,
    required this.isChain,
    this.address,
    required this.dateVisited,

    // TODO add back later since this is a bit more complex
    // this.labels,
    // this.peopleInvolved,
  });

  Restaurant copy({
    final int? id,
    final String? name,
    final bool? isChain,
    final String? address,
    final DateTime? dateVisited,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        isChain: isChain ?? this.isChain,
        address: address ?? this.address,
        dateVisited: dateVisited ?? this.dateVisited,
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
      );
}
