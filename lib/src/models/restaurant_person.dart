const String tableRestaurantPersons = 'restaurantPersonLink';

class RestaurantPersonFields {
  static final List<String> values = [
    restaurantId,
    personId,
  ];

  static const String restaurantId = 'restaurantId';
  static const String personId = 'personId';
}

class RestaurantPersonLink {
  final int restaurantId;
  final int personId;

  RestaurantPersonLink({
    required this.restaurantId,
    required this.personId,
  });

  RestaurantPersonLink copy({
    final int? restaurantId,
    final int? personId,
  }) =>
      RestaurantPersonLink(
        restaurantId: restaurantId ?? this.restaurantId,
        personId: personId ?? this.personId,
      );

  Map<String, Object?> toJson() => {
        RestaurantPersonFields.restaurantId: restaurantId,
        RestaurantPersonFields.personId: personId,
      };

  static RestaurantPersonLink fromJson(Map<String, Object?> json) =>
      RestaurantPersonLink(
        restaurantId: json[RestaurantPersonFields.restaurantId] as int,
        personId: json[RestaurantPersonFields.personId] as int,
      );
}
