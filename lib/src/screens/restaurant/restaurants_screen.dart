/*
V2:
  Filters on side menu
*/

import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database.dart';
import 'package:food_group_app/src/services/person_db.dart';
import 'package:food_group_app/src/services/restaurant_db.dart';

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

  @override
  void dispose() {
    DatabaseService.instance.close();
    super.dispose();
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
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(child: buildTileList()),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addRestaurantNew,
          );
          refreshRestaurants();
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Header',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Ratings'),
              leading: const Icon(Icons.star_border_rounded),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.ratings,
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('DELETE ALL PEOPLE'),
              leading: const Icon(Icons.person_remove_rounded),
              onTap: () async {
                List<Person> people = await PersonDatabase.readAllPersons();
                for (var e in people) {
                  PersonDatabase.deletePerson(e.id!);
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('See loader'),
              leading: const Icon(Icons.replay_circle_filled_outlined),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  AppRoutes.loader,
                  arguments: 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the tiles for all saved restaurants in the database.
  Widget buildTileList() => ListView.builder(
        itemCount: restaurants.length,
        prototypeItem: restaurants.isNotEmpty
            ? Card(
                child: ListTile(
                  title: Text(restaurants.first.name ?? ''),
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

  /// Handles navigating to the Add restaurant screen.
}
