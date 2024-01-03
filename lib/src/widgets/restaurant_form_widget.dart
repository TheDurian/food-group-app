import 'package:flutter/material.dart';
import 'package:food_group_app/src/screens/person/edit_person_screen.dart';

class RestaurantFormWidget extends StatefulWidget {
  final String? name;
  final bool? isChain;
  final String? address;
  final DateTime? dateVisited;
  final ValueChanged<String> onChangedName;
  final ValueChanged<bool> onChangedChain;
  final ValueChanged<String> onChangedAddress;
  final ValueChanged<DateTime> onChangedDateVisited;
  final VoidCallback onSubmit;

  const RestaurantFormWidget({
    Key? key,
    this.name = '',
    this.isChain = false,
    this.address = '',
    this.dateVisited,
    required this.onChangedName,
    required this.onChangedChain,
    required this.onChangedAddress,
    required this.onChangedDateVisited,
    required this.onSubmit,
  }) : super(key: key);

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
              SwitchListTile(
                title: const Text("Is this a chain?"),
                value: widget.isChain ?? false,
                onChanged: widget.onChangedChain,
              ),
              const SizedBox(height: 32),
              buildMultiSelectPeople(),
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
          border: OutlineInputBorder(),
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

  /// Builds the multiple person selection field.
  Widget buildMultiSelectPeople() => Container(
        child: GestureDetector(
          child: const Text("Add Person"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => const AddEditPersonScreen()),
            );
          },
        ),
      );
}
