// screen for the list of restaurants you have added

/*
V1
Scrollable list of all restaurants you have added.
Restaurants show up as cards that you scroll through. V1 design of just name is fine (or + date? idk)

Should have a FloatingActionButton (+) to add a new restaurant


V2:
  Filters on side menu
*/

import 'package:flutter/material.dart';
import 'package:food_group_app/src/screens/restaurant/edit_restaurant_screen.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key, required this.title});
  final String title;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  void _navigateToEditScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const EditRestaurantScreen(title: 'Edit')));
      }),
    );
  }
}
