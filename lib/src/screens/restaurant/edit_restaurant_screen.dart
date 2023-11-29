/*
Bunch of input fields:
1. Enter a name - box
2. Address - box
3. Date visited (click here for todays date) (datepicker)
4. Dropdown of labels
5. Is this a Chain? (checkbox)
6. People (multiple person dropdown)

Next button that goes to Ratings
*/

import 'package:flutter/material.dart';

class EditRestaurantScreen extends StatefulWidget {
  const EditRestaurantScreen({super.key, required this.title});
  final String title;

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  void _navigateToEditScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(),
    );
  }
}
