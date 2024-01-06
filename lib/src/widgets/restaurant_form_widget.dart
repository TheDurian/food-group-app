import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/screens/person/edit_person_screen.dart';
import 'package:food_group_app/src/services/database.dart';
import 'package:food_group_app/src/widgets/multi_select_dialog.dart';

class RestaurantFormWidget extends StatefulWidget {
  final String? name;
  final bool? isChain;
  final String? address;
  final DateTime? dateVisited;
  final List<Person> selectedPeople;
  final ValueChanged<String> onChangedName;
  final ValueChanged<bool> onChangedChain;
  final ValueChanged<String> onChangedAddress;
  final ValueChanged<DateTime> onChangedDateVisited;
  final ValueChanged<List<Person>> onChangedSelectedPeople;
  final VoidCallback onSubmit;

  const RestaurantFormWidget({
    super.key,
    this.name = '',
    this.isChain = false,
    this.address = '',
    this.dateVisited,
    required this.selectedPeople,
    required this.onChangedName,
    required this.onChangedChain,
    required this.onChangedAddress,
    required this.onChangedDateVisited,
    required this.onChangedSelectedPeople,
    required this.onSubmit,
  });

  @override
  _RestaurantFormWidgetState createState() => _RestaurantFormWidgetState();
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
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildName(),
              const SizedBox(height: 16),
              buildAddress(),
              const SizedBox(height: 16),
              buildDateVisited(context),
              const SizedBox(height: 16),
              buildMultiSelectPeople(),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Is this a chain?"),
                value: widget.isChain ?? false,
                onChanged: widget.onChangedChain,
              ),
              const SizedBox(height: 48),
              buildOnSubmit(),
            ],
          ),
        ),
      );

  /// Builds the name input field.
  Widget buildName() => TextFormField(
        maxLines: 1,
        initialValue: widget.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
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
  Widget buildAddress() => TextFormField(
        maxLines: 1,
        initialValue: widget.address,
        style: const TextStyle(
          fontSize: 18,
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

  /// Handles clicking on the save button
  Widget buildOnSubmit() => ElevatedButton(
        onPressed: widget.onSubmit,
        child: const Text("Save"),
      );

  /// Builds the input selection for a person list
  Widget buildSelectPeople() => InkWell(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              Expanded(
                child: Text("Add People"),
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        onTap: () async {
          var selectedPeople = await showDialog<List<Person>>(
            context: context,
            builder: (BuildContext context) => MultiSelectDialog<Person>(
              selectedItems: widget.selectedPeople,
              titleText: "Add People",
              onAddClick: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<Person>(
                    builder: (context) => const AddEditPersonScreen(),
                  ),
                );
              },
              buildSelectedItemText: Person.fullNameFromPerson,
              refreshAllItems: DatabaseService.instance.readAllPersons,
            ),
          );
          if (selectedPeople != null) {
            widget.onChangedSelectedPeople(selectedPeople);
          }
        },
      );

  /// Handles the long press functionality on a person chip.
  void _handleLongPressOnPersonChip(Person person) async {
    var newPerson = await Navigator.push(
      context,
      MaterialPageRoute<Person>(
        builder: (context) => AddEditPersonScreen(
          person: person,
        ),
      ),
    );
    if (newPerson != null) {
      // Probably really hacky solution
      var personToUpdate =
          widget.selectedPeople.indexWhere((e) => e.id == newPerson.id);
      var newList = List<Person>.from(widget.selectedPeople);
      newList[personToUpdate] = newPerson;
      setState(() {
        widget.onChangedSelectedPeople(newList);
      });
    }
  }

  /// Handles building the list of chips representing selected people.
  Widget buildPersonChips() => Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 5,
          runSpacing: -2,
          alignment: WrapAlignment.start,
          children: widget.selectedPeople
              .map((person) => InkWell(
                    onLongPress: () => _handleLongPressOnPersonChip(person),
                    child: Chip(
                      label: Text(person.fullName()),
                      avatar: const Icon(Icons.person_2_outlined),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        var selectedPeople = widget.selectedPeople
                            .where((e) => e != person)
                            .toList();
                        setState(() {
                          widget.onChangedSelectedPeople(selectedPeople);
                        });
                      },
                    ),
                  ))
              .toList(),
        ),
      );

  /// Builds the person selection with items.
  Widget buildMultiSelectPeople() => Column(
        children: [
          FormField(
            builder: (state) {
              return Column(
                children: [
                  buildSelectPeople(),
                  const SizedBox(height: 8),
                  buildPersonChips(),
                ],
              );
            },
          ),
        ],
      );
}
