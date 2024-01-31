import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/services/database/person_db.dart';
import 'package:food_group_app/src/utils/datetime_helper.dart';
import 'package:food_group_app/src/widgets/forms/person_form_widget.dart';

class AddEditPersonScreen extends StatefulWidget {
  final Person? person;

  const AddEditPersonScreen({
    super.key,
    this.person,
  });

  @override
  State<AddEditPersonScreen> createState() => _AddEditPersonScreenState();
}

class _AddEditPersonScreenState extends State<AddEditPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;

  @override
  void initState() {
    super.initState();

    firstName = widget.person?.firstName ?? '';
    lastName = widget.person?.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Person"),
        actions: buildActions(),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: PersonFormWidget(
              firstName: firstName,
              lastName: lastName,
              onChangedFirstName: (firstName) =>
                  setState(() => this.firstName = firstName),
              onChangedLastName: (lastName) =>
                  setState(() => this.lastName = lastName),
              onSubmit: _addOrUpdatePerson,
            ),
          ),
          if (widget.person != null) ...showOnEditInfo(),
        ],
      ),
    );
  }

  List<Widget> buildActions() => widget.person != null
      ? [
          IconButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirm deletion?"),
                content: const Text("Deleting this person will delete "
                    " all associated ratings they have provided.\n\n"
                    "Do you want to continue?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No, cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await PersonDatabase.deletePerson(
                        widget.person!.id!,
                      );
                      if (mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Yes, delete'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.delete),
          )
        ]
      : [];

  /// Show optional fields when editing.
  List<Widget> showOnEditInfo() => [
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        ),
        Text(
          "Person Added: "
          "${DateTimeHelper.toDateAndTime(widget.person!.dateAdded)}",
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          "Person Modified: "
          "${DateTimeHelper.toDateAndTime(widget.person!.dateModified)}",
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
        )
      ];

  /// Adds a new person or updates the current person in the database.
  ///
  /// Will only add/update the person if the form is valid.
  void _addOrUpdatePerson() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.person != null;

      Person dbPerson;
      if (isUpdating) {
        dbPerson = await _updatePerson();
      } else {
        dbPerson = await _addPerson();
      }
      if (mounted) Navigator.pop(context, dbPerson);
    }
  }

  /// Adds a new person to the database.
  Future<Person> _addPerson() async {
    final dateAdded = DateTime.now();

    return await PersonDatabase.createPerson(
      Person(
        firstName: firstName,
        lastName: lastName,
        dateAdded: dateAdded,
        dateModified: dateAdded,
      ),
    );
  }

  /// Updates an existing person in the database.
  Future<Person> _updatePerson() async {
    return PersonDatabase.updatePerson(
      widget.person!.copy(
        firstName: firstName,
        lastName: lastName,
        dateModified: DateTime.now(),
      ),
    );
  }
}
