class Rating {
  final String restaurantId;
  final String personId;

  final double? tasteRating;
  final double? serviceRating;
  final double? ambianceRating;
  final double? presentationRating;
  final double? costWorthRating;

  Rating({
    required this.restaurantId,
    required this.personId,
    required this.tasteRating,
    required this.serviceRating,
    required this.ambianceRating,
    required this.presentationRating,
    required this.costWorthRating,
  });
}
