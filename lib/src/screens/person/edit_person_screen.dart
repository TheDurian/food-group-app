import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/widgets/person_form_widget.dart';

class AddEditPersonScreen extends StatefulWidget {
  final Person? person;

  const AddEditPersonScreen({
    Key? key,
    this.person,
  }) : super(key: key);

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
        ),
      ),
    );
  }
}
