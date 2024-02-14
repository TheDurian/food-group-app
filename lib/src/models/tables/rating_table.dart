import 'package:food_group_app/src/models/tables/db_types.dart';
import 'package:food_group_app/src/models/tables/person_table.dart';
import 'package:food_group_app/src/models/tables/restaurant_table.dart';

const String tableRatings = 'ratings';
const String tableRatingsCreate = '''
      CREATE TABLE $tableRatings (
        ${RatingFields.restaurantId} ${DbTypes.integerType},
        ${RatingFields.personId} ${DbTypes.integerType},
        ${RatingFields.tasteRating} ${DbTypes.realNull},
        ${RatingFields.serviceRating} ${DbTypes.realNull},
        ${RatingFields.ambianceRating} ${DbTypes.realNull},
        ${RatingFields.presentationRating} ${DbTypes.realNull},
        ${RatingFields.costWorthRating} ${DbTypes.realNull},
        ${RatingFields.notes} ${DbTypes.textTypeNull},
        ${RatingFields.dateAdded} ${DbTypes.textType},
        ${RatingFields.dateModified} ${DbTypes.textType},
        FOREIGN KEY (${RatingFields.restaurantId})
          REFERENCES $tableRestaurants(${RestaurantFields.id}),
        FOREIGN KEY (${RatingFields.personId})
          REFERENCES $tablePersons(${PersonFields.id}),
        PRIMARY KEY (
          ${RatingFields.restaurantId},
          ${RatingFields.personId}
        )
      )
    ''';

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
