/*
Bunch of input fields:
1. Dropdown of labels
2. People (multiple person dropdown)

Next button that goes to Ratings
*/

import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/services/database.dart';
import 'package:food_group_app/src/widgets/restaurant_form_widget.dart';

class AddEditRestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;

  const AddEditRestaurantScreen({
    super.key,
    this.restaurant,
  });

  @override
  State<AddEditRestaurantScreen> createState() =>
      _AddEditRestaurantScreenState();
}

class _AddEditRestaurantScreenState extends State<AddEditRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late bool isChain;
  late String address;
  late DateTime dateVisited;
  List<Person> selectedPeople = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    name = widget.restaurant?.name ?? '';
    isChain = widget.restaurant?.isChain ?? false;
    address = widget.restaurant?.address ?? '';
    dateVisited = widget.restaurant?.dateVisited ?? DateTime(1900);
    selectedPeople = widget.restaurant?.persons ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(name),
      ),
      body: Form(
        key: _formKey,
        child: RestaurantFormWidget(
          name: name,
          isChain: isChain,
          address: address,
          dateVisited: dateVisited,
          selectedPeople: selectedPeople,
          onChangedName: (name) => setState(() => this.name = name),
          onChangedChain: (isChain) => setState(() => this.isChain = isChain),
          onChangedAddress: (address) => setState(() => this.address = address),
          onChangedDateVisited: (dateVisited) =>
              setState(() => this.dateVisited = dateVisited),
          onChangedSelectedPeople: (selectedPeople) =>
              setState(() => this.selectedPeople = selectedPeople),
          onSubmit: _addOrUpdateRestaurant,
        ),
      ),
    );
  }

  /// Attempts to add or update the restaurant.
  void _addOrUpdateRestaurant() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.restaurant != null;

      if (isUpdating) {
        await updateRestaurant();
      } else {
        await addRestaurant();
      }
      Navigator.pop(context);
    }
  }

  /// Updates the current restaurant in the database.
  Future<void> updateRestaurant() async {
    final restaurant = widget.restaurant!.copy(
      name: name,
      isChain: isChain,
      address: address,
      dateVisited: dateVisited,
      persons: selectedPeople,
    );
    await DatabaseService.instance.updateRestaurant(restaurant);
  }

  /// Adds a new restaurant to database.
  Future<void> addRestaurant() async {
    final restaurant = Restaurant(
      name: name,
      isChain: isChain,
      address: address,
      dateVisited: dateVisited,
      persons: selectedPeople,
    );
    await DatabaseService.instance.createRestaurant(restaurant);
  }
}
