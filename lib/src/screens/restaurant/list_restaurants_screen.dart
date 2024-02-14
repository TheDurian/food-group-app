import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/models/sorts/restaurant_sort.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database/database.dart';
import 'package:food_group_app/src/services/database/restaurant_db.dart';
import 'package:food_group_app/src/utils/extensions.dart';
import 'package:food_group_app/src/utils/shared_prefs.dart';
import 'package:food_group_app/src/widgets/cards/restaurant_card.dart';
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

  /// The current app version.
  String? _version;

  /// The selected filter.
  RestaurantSort selectedFilter = SharedPrefs().restaurantSort;

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
    sortRestaurants();
    setState(() => isLoading = false);
  }

  /// A function to sort the currently retrieved restaurants.
  ///
  /// This is to be used if no database call to re-fetch
  /// all restaurants is needed.
  void sortRestaurants() {
    setState(() => restaurants.sort(selectedFilter.sort));
  }

  /// A function that controls showing the filter modal.
  void showSortModal() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        showDragHandle: true,
        builder: (BuildContext context) => Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Sort",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: context.colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ...RestaurantSort.values.map(
                    (filter) => RadioListTile<RestaurantSort>(
                      title: Text(filter.name),
                      value: filter,
                      groupValue: selectedFilter,
                      onChanged: (RestaurantSort? value) {
                        if (value != null) {
                          setState(() {
                            selectedFilter = value;
                            SharedPrefs().restaurantSort = value;
                          });
                          sortRestaurants();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sorted by ${selectedFilter.name}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

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
          SliverAppBar.large(
            title: const Text('Restaurants'),
            pinned: true,
            actions: [
              IconButton(
                onPressed: showSortModal,
                icon: const Icon(Icons.sort),
              ),
            ],
          ),
          isLoading
              ? const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: restaurants.length,
                    (context, index) => GestureDetector(
                      onTap: () => onAddEditClick(restaurants[index]),
                      child: RestaurantCard(
                        restaurant: restaurants[index],
                      ),
                    ),
                  ),
                ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
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
  // Widget buildTileList() => ListView.builder(
  //       itemCount: restaurants.length,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           child:
  //           onLongPress: () async {
  //             RestaurantDatabase.deleteRestaurant(restaurants[index].id!);
  //             refreshRestaurants();
  //           },
  //           onTap: () => onAddEditClick(restaurants[index]),
  //         );
  //       },
  //       shrinkWrap: true,
  //       scrollDirection: Axis.vertical,
  //     );

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
