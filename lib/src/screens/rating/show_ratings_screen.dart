import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/routes/arguments.dart';
import 'package:food_group_app/src/services/database/person_db.dart';
import 'package:food_group_app/src/services/database/rating_db.dart';
import 'package:food_group_app/src/services/database/restaurant_db.dart';

class ShowRatingsScreen extends StatefulWidget {
  const ShowRatingsScreen({
    super.key,
  });

  @override
  State<ShowRatingsScreen> createState() => _ShowRatingsScreenState();
}

class _ShowRatingsScreenState extends State<ShowRatingsScreen> {
  late List<Rating> ratings;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ratings = [];
    refreshRatings();
  }

  /// Refresh the active ratings.
  Future<void> refreshRatings() async {
    setState(() => isLoading = true);
    ratings = await RatingDatabase.readAllRatings();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildTileList(),
      );

  /// Builds the tiles for all saved restaurants in the database.
  Widget buildTileList() => ListView.builder(
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              Navigator.pushNamed(
                context,
                AppRoutes.addRating,
                arguments: RatingScreenArguments(
                  await RestaurantDatabase.readRestaurant(
                    ratings[index].restaurantId,
                  ),
                  await PersonDatabase.readPerson(
                    ratings[index].personId,
                  ),
                  ratings[index],
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Text('RestaurantId: ${ratings[index].restaurantId}'),
                  Text('PersonId: ${ratings[index].personId}'),
                  Text('Taste: ${ratings[index].tasteRating}'),
                  Text('Service: ${ratings[index].serviceRating}'),
                  Text('Ambiance: ${ratings[index].ambianceRating}'),
                  Text('Presentation: ${ratings[index].presentationRating}'),
                  Text('CostWorth: ${ratings[index].costWorthRating}'),
                  Text('DateAdded: ${ratings[index].dateAdded}'),
                  Text('DateModified: ${ratings[index].dateModified}'),
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      );
}
