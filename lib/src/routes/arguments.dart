import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant.dart';

class RatingScreenArguments {
  final Restaurant restaurant;
  final Person person;
  final Rating? rating;

  RatingScreenArguments(this.restaurant, this.person, this.rating);
}
