import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database/restaurant_db.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  /// A list of restaurants to show.
  late List<Restaurant> restaurants;

  /// A flag for whether a database call is ongoing or not.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    restaurants = [];
    refreshRestaurants();
  }

  /// Refresh the active restaurants.
  Future<void> refreshRestaurants() async {
    setState(() => isLoading = true);
    restaurants = await RestaurantDatabase.readAllRestaurants();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Restaurants'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.settings),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildTileList(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            AppRoutes.addRestaurant,
          );
          refreshRestaurants();
        },
        label: const Text('New Restaurant'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the tiles for all saved restaurants in the database.
  Widget buildTileList() => ListView.builder(
        itemCount: restaurants.length,
        prototypeItem: restaurants.isNotEmpty
            ? Card(
                child: ListTile(
                  title: Text(restaurants.first.name),
                ),
              )
            : null,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              child: ListTile(
                title: Text(restaurants[index].name),
                subtitle: Text(restaurants[index].dateVisited.toString()),
                trailing: Text('${restaurants[index].id}'),
              ),
            ),
            onLongPress: () async {
              RestaurantDatabase.deleteRestaurant(restaurants[index].id!);
              refreshRestaurants();
            },
            onTap: () => onAddEditClick(restaurants[index]),
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      );

  /// Handles navigating to the Add/Edit restaurant screen.
  void onAddEditClick([Restaurant? restaurant]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.editRestaurant,
      arguments: restaurant,
    );
    refreshRestaurants();
  }
}
