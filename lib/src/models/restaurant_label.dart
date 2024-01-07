const String tableRestaurantLabels = 'restaurantLabelLink';

class RestaurantLabelFields {
  static final List<String> values = [
    restaurantId,
    labelId,
  ];

  static const String restaurantId = 'restaurantId';
  static const String labelId = 'labelId';
}

class RestaurantLabelLink {
  final int restaurantId;
  final int labelId;

  RestaurantLabelLink({
    required this.restaurantId,
    required this.labelId,
  });

  RestaurantLabelLink copy({
    final int? restaurantId,
    final int? labelId,
  }) =>
      RestaurantLabelLink(
        restaurantId: restaurantId ?? this.restaurantId,
        labelId: labelId ?? this.labelId,
      );

  Map<String, Object?> toJson() => {
        RestaurantLabelFields.restaurantId: restaurantId,
        RestaurantLabelFields.labelId: labelId,
      };

  static RestaurantLabelLink fromJson(Map<String, Object?> json) =>
      RestaurantLabelLink(
        restaurantId: json[RestaurantLabelFields.restaurantId] as int,
        labelId: json[RestaurantLabelFields.labelId] as int,
      );
}
