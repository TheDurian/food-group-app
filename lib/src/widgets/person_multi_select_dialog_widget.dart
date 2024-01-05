import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/screens/person/edit_person_screen.dart';
import 'package:food_group_app/src/services/database.dart';

class PersonMultiSelectDialog extends StatefulWidget {
  final List<Person> selectedPeople;

  const PersonMultiSelectDialog({
    super.key,
    required this.selectedPeople,
  });

  @override
  State<PersonMultiSelectDialog> createState() =>
      _PersonMultiSelectDialogState();
}

class _PersonMultiSelectDialogState extends State<PersonMultiSelectDialog> {
  late Map<Person, bool> peopleChecked;
  bool isLoading = false;
  late List<Person> allPeople = [];

  @override
  void initState() {
    super.initState();
    refreshPeople();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: buildTitle(),
        content: buildContent(),
        actions: buildActionButtons(),
      );

  /// Refresh the active persons.
  Future<void> refreshPeople() async {
    setState(() => isLoading = true);
    allPeople = await DatabaseService.instance.readAllPersons();
    peopleChecked = {
      for (var e in allPeople) e: widget.selectedPeople.contains(e)
    };
    setState(() => isLoading = false);
  }

  /// Builds the action buttons on the alert dialog.
  ///
  /// The confirmation button will not appear unless
  /// at least 1 person has previously been added.
  List<Widget> buildActionButtons() => [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        if (allPeople.isNotEmpty)
          ElevatedButton(
            onPressed: () => Navigator.pop(
                context,
                peopleChecked.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList()),
            child: const Text("Confirm"),
          ),
      ];

  /// Builds the central content of the alert dialog.
  ///
  /// Content will show a loading indicator if the list
  /// of people have not yet been pulled from the database.
  Widget buildContent() => isLoading
      ? const Center(child: CircularProgressIndicator())
      : Container(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: peopleChecked.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Person key = peopleChecked.keys.elementAt(index);
              return CheckboxListTile(
                title: Text(
                  "${key.firstName} ${key.lastName}",
                ),
                value: peopleChecked.values.elementAt(index),
                onChanged: (bool? value) {
                  setState(() => peopleChecked[key] = value ?? false);
                },
              );
            },
          ),
        );

  /// Builds the title section of the alert dialog
  Widget buildTitle() => Row(
        children: [
          const Expanded(child: Text("Select people")),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<Person>(
                  builder: (context) => const AddEditPersonScreen(),
                ),
              );
              refreshPeople();
            },
          ),
        ],
      );
}
