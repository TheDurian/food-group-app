import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/services/person_db.dart';
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("$firstName $lastName"),
      ),
      body: Form(
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
    );
  }

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
      Navigator.pop(context, dbPerson);
    }
  }

  /// Adds a new person to the database.
  Future<Person> _addPerson() async {
    final person = Person(
      firstName: firstName,
      lastName: lastName,
    );

    var dbPerson = await PersonDatabase.createPerson(person);
    return dbPerson;
  }

  /// Updates an existing person in the database.
  Future<Person> _updatePerson() async {
    final person = widget.person!.copy(
      firstName: firstName,
      lastName: lastName,
    );

    var dbPerson = await PersonDatabase.updatePerson(person);
    return dbPerson;
  }
}
