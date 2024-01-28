import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';

class PersonSort {
  static const String alphabetical = 'Alphabetical';
  static const String mostRatings = 'Most Ratings';
  static const String leastRatings = 'Least Ratings';
  static const String newlyAdded = 'Newly Added';
  static const String oldestAdded = 'Oldest Added';

  static const List<String> values = [
    alphabetical,
    mostRatings,
    leastRatings,
    newlyAdded,
    oldestAdded,
  ];

  static int alphabeticalSort(
          Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
      a.entries.first.key
          .fullName()
          .toLowerCase()
          .compareTo(b.entries.first.key.fullName().toLowerCase());

  static int mostRatingsSort(
          Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
      b.entries.first.value.length - a.entries.first.value.length;

  static int leastRatingsSort(
          Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
      a.entries.first.value.length - b.entries.first.value.length;

  static int newlyAddedSort(
          Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
      b.entries.first.key.dateAdded.compareTo(a.entries.first.key.dateAdded);

  static int oldestAddedSort(
          Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
      a.entries.first.key.dateAdded.compareTo(b.entries.first.key.dateAdded);
}
