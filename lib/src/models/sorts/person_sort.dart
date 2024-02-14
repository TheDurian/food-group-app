import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';

int alphabeticalSort(
        Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
    a.entries.first.key
        .fullName()
        .toLowerCase()
        .compareTo(b.entries.first.key.fullName().toLowerCase());
int mostRatingsSort(Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
    b.entries.first.value.length - a.entries.first.value.length;
int leastRatingsSort(
        Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
    a.entries.first.value.length - b.entries.first.value.length;
int newlyAddedSort(Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
    b.entries.first.key.dateAdded.compareTo(a.entries.first.key.dateAdded);
int oldestAddedSort(Map<Person, List<Rating>> a, Map<Person, List<Rating>> b) =>
    a.entries.first.key.dateAdded.compareTo(b.entries.first.key.dateAdded);

enum PersonSort {
  alphabetical('Alphabetical', alphabeticalSort),
  mostRatings('Most Ratings', mostRatingsSort),
  leastRatings('Least Ratings', leastRatingsSort),
  newlyAdded('Newly Added', newlyAddedSort),
  oldestAdded('Oldest Added', oldestAddedSort);

  const PersonSort(this.name, this.sort);

  static PersonSort searchByName(String name) {
    for (var value in PersonSort.values) {
      if (value.name.toLowerCase() == name.toLowerCase()) return value;
    }
    throw ArgumentError.value(name, "name", "No enum value with that name");
  }

  final String name;
  final int Function(Map<Person, List<Rating>>, Map<Person, List<Rating>>) sort;
}
