const String tableRatings = 'ratings';

class RatingFields {
  static final List<String> values = [
    restaurantId,
    personId,
    tasteRating,
    serviceRating,
    ambianceRating,
    presentationRating,
    costWorthRating,
    notes,
    dateAdded,
    dateModified,
  ];

  static const String restaurantId = 'restaurantId';
  static const String personId = 'personId';
  static const String tasteRating = 'tasteRating';
  static const String serviceRating = 'serviceRating';
  static const String ambianceRating = 'ambianceRating';
  static const String presentationRating = 'presentationRating';
  static const String costWorthRating = 'costWorthRating';
  static const String notes = 'notes';
  static const String dateAdded = 'dateAdded';
  static const String dateModified = 'dateModified';
}

class Rating {
  /// The associated restaurant for this rating.
  final int restaurantId;

  /// The associated person who made this rating.
  final int personId;

  /// The rating for taste aka how good this meal was.
  final double? tasteRating;

  /// The rating for how good the service was.
  final double? serviceRating;

  /// The rating for the ambiance of the restaurant aka the vibes
  final double? ambianceRating;

  /// The rating for how the food was presented.
  final double? presentationRating;

  /// The rating for if this meal felt like it was worth the cost.
  final double? costWorthRating;

  /// Any general notes the person would like to include.
  final String? notes;
  //TODO: add optional "overall rating" that you can do instead of multiple mini ratings

  /// The date this rating was added to the database.
  final DateTime? dateAdded;

  /// The date this rating was last modified.
  final DateTime? dateModified;

  Rating({
    required this.restaurantId,
    required this.personId,
    this.tasteRating,
    this.serviceRating,
    this.ambianceRating,
    this.presentationRating,
    this.costWorthRating,
    this.notes,
    this.dateAdded,
    this.dateModified,
  });

  Rating copy({
    final int? restaurantId,
    final int? personId,
    final double? tasteRating,
    final double? serviceRating,
    final double? ambianceRating,
    final double? presentationRating,
    final double? costWorthRating,
    final String? notes,
    final DateTime? dateAdded,
    final DateTime? dateModified,
  }) =>
      Rating(
        restaurantId: restaurantId ?? this.restaurantId,
        personId: personId ?? this.personId,
        tasteRating: tasteRating ?? this.tasteRating,
        serviceRating: serviceRating ?? this.serviceRating,
        ambianceRating: ambianceRating ?? this.ambianceRating,
        presentationRating: presentationRating ?? this.presentationRating,
        costWorthRating: costWorthRating ?? this.costWorthRating,
        notes: notes ?? this.notes,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
      );

  Map<String, Object?> toJson() => {
        RatingFields.restaurantId: restaurantId,
        RatingFields.personId: personId,
        RatingFields.tasteRating: tasteRating,
        RatingFields.serviceRating: serviceRating,
        RatingFields.ambianceRating: ambianceRating,
        RatingFields.presentationRating: presentationRating,
        RatingFields.costWorthRating: costWorthRating,
        RatingFields.notes: notes,
        RatingFields.dateAdded: dateAdded?.toIso8601String(),
        RatingFields.dateModified: dateModified?.toIso8601String(),
      };

  static Rating fromJson(Map<String, Object?> json) => Rating(
        restaurantId: json[RatingFields.restaurantId] as int,
        personId: json[RatingFields.personId] as int,
        tasteRating: json[RatingFields.tasteRating] as double,
        serviceRating: json[RatingFields.serviceRating] as double,
        ambianceRating: json[RatingFields.ambianceRating] as double,
        presentationRating: json[RatingFields.presentationRating] as double,
        costWorthRating: json[RatingFields.costWorthRating] as double,
        notes: json[RatingFields.notes] as String,
        dateAdded: DateTime.parse(json[RatingFields.dateAdded] as String),
        dateModified: DateTime.parse(json[RatingFields.dateModified] as String),
      );

  @override
  bool operator ==(Object other) =>
      other is Rating &&
      other.restaurantId == restaurantId &&
      other.personId == personId;

  @override
  int get hashCode {
    int result = 17;
    result = 31 * result + restaurantId;
    result = 31 * result + personId;
    return result;
  }
}
