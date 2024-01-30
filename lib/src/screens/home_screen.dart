import 'package:flutter/material.dart';
import 'package:food_group_app/src/screens/person/list_people_screen.dart';
import 'package:food_group_app/src/screens/rating/show_ratings_screen.dart';
import 'package:food_group_app/src/screens/restaurant/list_restaurants_screen.dart';
import 'package:food_group_app/src/services/database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final List<Widget> screens = [
    const RestaurantScreen(),
    const ListPeopleScreen(),
    const ShowRatingsScreen(),
  ];

  @override
  void dispose() {
    DatabaseService.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          animationDuration: const Duration(seconds: 1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.food_bank),
              tooltip: 'Restaurants',
              label: 'Restaurants',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              tooltip: 'People',
              label: 'People',
            ),
            NavigationDestination(
              icon: Icon(Icons.star),
              tooltip: 'Ratings',
              label: 'Ratings',
            ),
          ],
        ),
      );
}
