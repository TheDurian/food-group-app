import 'package:food_group_app/src/models/restaurant.dart';

int alphabeticalSort(Restaurant a, Restaurant b) => a.name.compareTo(b.name);
int mostRatingsSort(Restaurant a, Restaurant b) =>
    b.ratings!.length.compareTo(a.ratings!.length);
int leastRatingsSort(Restaurant a, Restaurant b) =>
    a.ratings!.length.compareTo(b.ratings!.length);
int highestRatingSort(Restaurant a, Restaurant b) =>
    b.getAverageRating().compareTo(a.getAverageRating());
int lowestRatingSort(Restaurant a, Restaurant b) =>
    a.getAverageRating().compareTo(b.getAverageRating());
int newlyVisitedSort(Restaurant a, Restaurant b) =>
    b.dateVisited.compareTo(a.dateVisited);
int oldestVisitedSort(Restaurant a, Restaurant b) =>
    a.dateVisited.compareTo(b.dateVisited);

enum RestaurantSort {
  alphabetical('Alphabetical', alphabeticalSort),
  mostRatings('Most Ratings', mostRatingsSort),
  leastRatings('Least Ratings', leastRatingsSort),
  highestRating('Highest Rating', highestRatingSort),
  lowestRating('Lowest Rating', lowestRatingSort),
  newlyVisited('Newly Visited', newlyVisitedSort),
  oldestVisited('Oldest Visited', oldestVisitedSort);

  const RestaurantSort(this.name, this.sort);

  static RestaurantSort searchByName(String name) {
    for (var value in RestaurantSort.values) {
      if (value.name.toLowerCase() == name.toLowerCase()) return value;
    }
    throw ArgumentError.value(name, "name", "No enum value with that name");
  }

  final String name;
  final int Function(Restaurant, Restaurant) sort;
}
