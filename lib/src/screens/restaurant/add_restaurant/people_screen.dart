import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/person_db.dart';
import 'package:food_group_app/src/widgets/inputs/multi_select_input_widget.dart';

class AddRestaurantPeopleScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddRestaurantPeopleScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<AddRestaurantPeopleScreen> createState() =>
      _AddRestaurantPeopleScreenState();
}

class _AddRestaurantPeopleScreenState extends State<AddRestaurantPeopleScreen> {
  /// A list of the currently selected people.
  late List<Person> selectedPeople;

  @override
  void initState() {
    super.initState();
    selectedPeople = widget.restaurant.persons ?? [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Hero(
                  tag: 'restaurantIcon',
                  child: Icon(Icons.food_bank_outlined, size: 100),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Would you like to add any people?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Each person will have a chance to give their own rating',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: MultiSelectInput<Person>(
                    chipAlignment: Alignment.centerLeft,
                    labelAvatar: const Icon(Icons.person_2_outlined),
                    inputHintText: "Select people",
                    selectedItems: selectedPeople,
                    onChangedSelectedItems: (people) =>
                        setState(() => selectedPeople = people),
                    buildSelectedItemText: Person.fullNameFromPerson,
                    titleText: "Select People",
                    onAddClick: () async => await Navigator.pushNamed(
                      context,
                      AppRoutes.editPerson,
                    ),
                    refreshAllItems: PersonDatabase.readAllPersons,
                    onChipLongPress: (people) => Navigator.pushNamed(
                      context,
                      AppRoutes.editPerson,
                      arguments: people,
                    ),
                    inputDecoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 180,
                  child: FilledButton.tonal(
                    onPressed: onSubmit,
                    child: Text(
                      selectedPeople.isEmpty ? 'Skip' : 'Continue',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      );

  /// Handle logic when clicking the submit button or tapping next
  void onSubmit() => Navigator.pushNamed(
        context,
        AppRoutes.addRestaurantOther,
        arguments: widget.restaurant.copy(persons: selectedPeople),
      );
}
