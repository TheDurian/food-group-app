import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/database/label_db.dart';
import 'package:food_group_app/src/services/database/person_db.dart';
import 'package:food_group_app/src/utils/extensions.dart';
import 'package:food_group_app/src/widgets/inputs/multi_select_input_widget.dart';

class RestaurantFormWidget extends StatefulWidget {
  /// The name of a restaurant.
  final String? name;

  /// Whether this restaurant is a chain or not.
  final bool? isChain;

  /// The address of a restaurant.
  final String? address;

  /// The date this restaurant was visited.
  final DateTime? dateVisited;

  /// A list of people involved in the visit to this restaurant.
  final List<Person> selectedPeople;

  /// A list of labels defining this visit to this restaurant.
  final List<Label> selectedLabels;

  /// A function to call when the name has changed.
  final ValueChanged<String> onChangedName;

  /// A function to call when the chain status has changed.
  final ValueChanged<bool> onChangedIsChain;

  /// A function to call when the address has changed.
  final ValueChanged<String> onChangedAddress;

  /// A function to call when the visited date has changed.
  final ValueChanged<DateTime> onChangedDateVisited;

  /// A function to call when the list of people involved has changed.
  final ValueChanged<List<Person>> onChangedSelectedPeople;

  /// A function to call when the list of labels has changed.
  final ValueChanged<List<Label>> onChangedSelectedLabels;

  /// A function to call when this form is submitted.
  final VoidCallback onSubmit;

  const RestaurantFormWidget({
    super.key,
    this.name = '',
    this.isChain = false,
    this.address = '',
    this.dateVisited,
    required this.selectedPeople,
    required this.selectedLabels,
    required this.onChangedName,
    required this.onChangedIsChain,
    required this.onChangedAddress,
    required this.onChangedDateVisited,
    required this.onChangedSelectedPeople,
    required this.onChangedSelectedLabels,
    required this.onSubmit,
  });

  @override
  State<RestaurantFormWidget> createState() => _RestaurantFormWidgetState();
}

class _RestaurantFormWidgetState extends State<RestaurantFormWidget> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.dateVisited != null && widget.dateVisited != DateTime(1900)
          ? "${widget.dateVisited!.month}/${widget.dateVisited!.month}/${widget.dateVisited!.year}"
          : '',
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildName(context),
            const SizedBox(height: 16),
            buildAddress(context),
            const SizedBox(height: 16),
            buildDateVisited(context),
            const SizedBox(height: 16),
            buildSelectPeople(),
            const SizedBox(height: 16),
            buildSelectLabels(),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Is this a chain?"),
              value: widget.isChain ?? false,
              onChanged: widget.onChangedIsChain,
            ),
            const SizedBox(height: 48),
            buildSave(context),
          ],
        ),
      );

  /// Builds the name input field.
  Widget buildName(BuildContext context) => TextFormField(
        maxLines: 1,
        initialValue: widget.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.onPrimaryContainer,
        ),
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Restaurant Name',
          labelText: 'Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'The name cannot be empty' : null,
        onChanged: widget.onChangedName,
        textInputAction: TextInputAction.next,
      );

  /// Builds the address input field.
  Widget buildAddress(BuildContext context) => TextFormField(
        maxLines: 1,
        initialValue: widget.address,
        style: TextStyle(
          color: context.colorScheme.onPrimaryContainer,
        ),
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Restaurant Address',
          labelText: 'Address',
        ),
        onChanged: widget.onChangedAddress,
        textInputAction: TextInputAction.done,
      );

  /// Builds the date visited input field.
  Widget buildDateVisited(BuildContext context) => TextFormField(
        controller: _dateController,
        maxLines: 1,
        style: TextStyle(
          color: context.colorScheme.onPrimaryContainer,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Date Visited',
          labelText: 'Date Visited',
          prefixIcon: const Icon(Icons.calendar_month),
          suffixIcon:
              widget.dateVisited != null && widget.dateVisited != DateTime(1900)
                  ? Tooltip(
                      message: "Clear Date",
                      child: InkWell(
                        child: const Icon(Icons.close),
                        onTap: () {
                          widget.onChangedDateVisited(DateTime(1900));
                          _dateController.text = "";
                        },
                      ),
                    )
                  : null,
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: (dateVisited) => dateVisited != null && dateVisited.isEmpty
            ? 'The date visited cannot be empty'
            : null,
      );

  /// Handles logic for selecting a date in the date picker.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (datePicked != null && datePicked != widget.dateVisited) {
      setState(() {
        widget.onChangedDateVisited(datePicked);
        _dateController.text =
            "${datePicked.month}/${datePicked.month}/${datePicked.year}";
      });
    }
  }

  /// Builds the select people input field.
  Widget buildSelectPeople() => MultiSelectInput<Person>(
        inputHintText: "Add people",
        labelAvatar: const Icon(Icons.person_2_outlined),
        selectedItems: widget.selectedPeople,
        onChangedSelectedItems: widget.onChangedSelectedPeople,
        buildSelectedItemText: Person.fullNameFromPerson,
        onChipLongPress: (person) => Navigator.pushNamed(
          context,
          AppRoutes.editPerson,
          arguments: person,
        ),
        titleText: "Select People",
        onAddClick: () async => await Navigator.pushNamed(
          context,
          AppRoutes.editPerson,
        ),
        refreshAllItems: PersonDatabase.readAllPersons,
        inputDecoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      );

  /// Builds the select labels input field.
  Widget buildSelectLabels() => MultiSelectInput<Label>(
        inputHintText: "Add/Select labels",
        selectedItems: widget.selectedLabels,
        onChangedSelectedItems: widget.onChangedSelectedLabels,
        buildSelectedItemText: (e) => e.label,
        onChipLongPress: (label) => Navigator.pushNamed(
          context,
          AppRoutes.editLabel,
          arguments: label,
        ),
        titleText: "Select Labels",
        onAddClick: () async => await Navigator.pushNamed(
          context,
          AppRoutes.editLabel,
        ),
        chipColor: (label) => label.color,
        refreshAllItems: LabelDatabase.readAllLabels,
        inputDecoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      );

  /// Builds the save button.
  Widget buildSave(BuildContext context) => SizedBox(
        width: double.maxFinite,
        child: FilledButton(
          onPressed: widget.onSubmit,
          child: const Text('Save'),
        ),
      );
}
