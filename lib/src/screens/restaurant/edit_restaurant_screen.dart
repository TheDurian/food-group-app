import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/services/restaurant_db.dart';
import 'package:food_group_app/src/widgets/restaurant_form_widget.dart';

class AddEditRestaurantScreen extends StatefulWidget {
  /// A restaurant to prefill data on the edit screen.
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
  /// Form key to keep current form state.
  final _formKey = GlobalKey<FormState>();

  /// The name of a restaurant.
  late String name;

  /// Whether this restaurant is a chain or not.
  late bool isChain;

  /// The address of a restaurant.
  late String address;

  /// The date the restaurant was visited.
  late DateTime dateVisited;

  /// A list of people involved with the visit to the restaurant.
  List<Person> selectedPeople = [];

  /// A list of labels defining the visit to the restaurant.
  List<Label> selectedLabels = [];

  /// A flag for whether a database call is ongoing or not.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    name = widget.restaurant?.name ?? '';
    isChain = widget.restaurant?.isChain ?? false;
    address = widget.restaurant?.address ?? '';
    dateVisited = widget.restaurant?.dateVisited ?? DateTime(1900);
    selectedPeople = widget.restaurant?.persons ?? [];
    selectedLabels = widget.restaurant?.labels ?? [];
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
          selectedLabels: selectedLabels,
          onChangedName: (name) => setState(() => this.name = name),
          onChangedIsChain: (isChain) => setState(() => this.isChain = isChain),
          onChangedAddress: (address) => setState(() => this.address = address),
          onChangedDateVisited: (dateVisited) =>
              setState(() => this.dateVisited = dateVisited),
          onChangedSelectedPeople: (selectedPeople) =>
              setState(() => this.selectedPeople = selectedPeople),
          onChangedSelectedLabels: (selectedLabels) =>
              setState(() => this.selectedLabels = selectedLabels),
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
      labels: selectedLabels,
    );
    await RestaurantDatabase.updateRestaurant(restaurant);
  }

  /// Adds a new restaurant to database.
  Future<void> addRestaurant() async {
    final restaurant = Restaurant(
      name: name,
      isChain: isChain,
      address: address,
      dateVisited: dateVisited,
      persons: selectedPeople,
      labels: selectedLabels,
    );
    await RestaurantDatabase.createRestaurant(restaurant);
  }
}
