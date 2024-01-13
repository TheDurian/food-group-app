import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/label_db.dart';
import 'package:food_group_app/src/widgets/inputs/multi_select_input_widget.dart';

class AddRestaurantLabelsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddRestaurantLabelsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<AddRestaurantLabelsScreen> createState() =>
      _AddRestaurantLabelsScreenState();
}

class _AddRestaurantLabelsScreenState extends State<AddRestaurantLabelsScreen> {
  /// A list of the currently selected labels.
  late List<Label> selectedLabels;

  @override
  void initState() {
    super.initState();
    selectedLabels = widget.restaurant.labels ?? [];
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
                    'Would you like to add any labels?',
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Note:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ' Adding labels helps you sort and tag your visits!',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: MultiSelectInput<Label>(
                    chipAlignment: Alignment.centerLeft,
                    inputHintText: "Select labels",
                    selectedItems: selectedLabels,
                    onChangedSelectedItems: (labels) =>
                        setState(() => selectedLabels = labels),
                    buildSelectedItemText: (label) => label.label,
                    titleText: "Select Labels",
                    onAddClick: () async => await Navigator.pushNamed(
                      context,
                      AppRoutes.editLabel,
                    ),
                    refreshAllItems: LabelDatabase.readAllLabels,
                    onChipLongPress: (label) => Navigator.pushNamed(
                      context,
                      AppRoutes.editLabel,
                      arguments: label,
                    ),
                    chipColor: (label) => label.color,
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
                      selectedLabels.isEmpty ? 'Skip' : 'Continue',
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
        AppRoutes.addRestaurantPeople,
        arguments: widget.restaurant.copy(labels: selectedLabels),
      );
}
