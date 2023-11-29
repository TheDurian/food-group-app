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
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/screens/restaurant/edit_restaurant_screen.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Restaurant> restaurants = [
      Restaurant(
        id: "id1",
        name: "McDonalds",
        dateVisited: DateTime.parse("2023-01-01"),
        peopleInvolved: [
          Person(id: "id1", firstName: "Darian", lastName: "Puka"),
        ],
      ),
      Restaurant(
        id: "id2",
        name: "Jimmy Johns",
        dateVisited: DateTime.parse("2023-03-01"),
        peopleInvolved: [
          Person(id: "id1", firstName: "Darian", lastName: "Puka"),
          Person(id: "id2", firstName: "Ross", lastName: "Campbell"),
          Person(id: "id3", firstName: "Louie", lastName: "Simbajon"),
        ],
      ),
      Restaurant(
        id: "id3",
        name: "Chipotle",
        dateVisited: DateTime.parse("2023-02-01"),
        peopleInvolved: [
          Person(id: "id1", firstName: "Darian", lastName: "Puka"),
          Person(id: "id2", firstName: "Ross", lastName: "Campbell"),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Restaurants"),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        prototypeItem: Card(
            child: ListTile(
          title: Text(restaurants.first.name),
        )),
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(restaurants[index].name),
            subtitle: Text(restaurants[index].dateVisited.toString()),
            trailing: Text(
                restaurants[index].peopleInvolved?.length.toString() ?? ''),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) =>
                      const EditRestaurantScreen(title: 'Edit')));
        },
      ),
    );
  }
}
