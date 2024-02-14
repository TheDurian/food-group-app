import 'package:food_group_app/src/models/tables/db_types.dart';

const String tableRestaurants = 'restaurants';
const String tableRestaurantsCreate = '''
      CREATE TABLE $tableRestaurants (
        ${RestaurantFields.id} ${DbTypes.idType},
        ${RestaurantFields.placeId} ${DbTypes.textType},
        ${RestaurantFields.name} ${DbTypes.textType},
        ${RestaurantFields.isChain} ${DbTypes.boolTypeNull},
        ${RestaurantFields.address} ${DbTypes.textTypeNull},
        ${RestaurantFields.dateVisited} ${DbTypes.textTypeNull},
        ${RestaurantFields.dateAdded} ${DbTypes.textType},
        ${RestaurantFields.dateModified} ${DbTypes.textType},
        ${RestaurantFields.photoReference} ${DbTypes.textType}
      )
    ''';

class RestaurantFields {
  static final List<String> values = [
    id,
    placeId,
    name,
    isChain,
    address,
    dateVisited,
    dateAdded,
    dateModified,
    photoReference,
  ];

  static const String id = '_id';
  static const String placeId = 'placeId';
  static const String name = 'name';
  static const String isChain = 'isChain';
  static const String address = 'address';
  static const String dateVisited = 'dateVisited';
  static const String persons = 'persons';
  static const String labels = 'labels';
  static const String ratings = 'ratings';
  static const String dateAdded = 'dateAdded';
  static const String dateModified = 'dateModified';
  static const String photoReference = 'photoReference';
}
