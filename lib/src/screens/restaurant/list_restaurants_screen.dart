import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database/database.dart';
import 'package:food_group_app/src/services/database/restaurant_db.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  String? _version;

  @override
  void initState() {
    super.initState();
    getPackageVersion();
    restaurants = [];
    refreshRestaurants();
  }

  void getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() => _version = packageInfo.version);
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
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('People'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.listPeople),
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text('Labels'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.listLabels),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text('Reports'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            const Spacer(),
            ListTile(
              title: Text('App Version: $_version'),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Restaurants'),
            pinned: true,
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
