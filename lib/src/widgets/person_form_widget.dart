import 'package:flutter/material.dart';

class PersonFormWidget extends StatelessWidget {
  /// The first name of a person.
  final String? firstName;

  /// The last name of a person.
  final String? lastName;

  /// A function to call when the first name has changed.
  final ValueChanged<String> onChangedFirstName;

  /// A function to call when the last name has changed.
  final ValueChanged<String> onChangedLastName;

  /// A function to call when the submit button is clicked.
  final VoidCallback onSubmit;

  const PersonFormWidget({
    super.key,
    this.firstName = '',
    this.lastName = '',
    required this.onChangedFirstName,
    required this.onChangedLastName,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildFirstName(),
              const SizedBox(height: 16),
              buildLastName(),
              const SizedBox(height: 32),
              buildSave(),
            ],
          ),
        ),
      );

  /// Builds the first name input field
  Widget buildFirstName() => TextFormField(
        maxLines: 1,
        initialValue: firstName,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'First Name',
          labelText: 'First Name',
        ),
        validator: (firstName) => firstName != null && firstName.isEmpty
            ? 'The first name cannot be empty'
            : null,
        onChanged: onChangedFirstName,
        textInputAction: TextInputAction.next,
      );

  /// Builds the last name input field
  Widget buildLastName() => TextFormField(
        maxLines: 1,
        initialValue: lastName,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Last Name (Optional)',
          labelText: 'Last Name (Optional)',
        ),
        onChanged: onChangedLastName,
        textInputAction: TextInputAction.next,
      );

  Widget buildSave() => Row(
        children: [
          Expanded(
            child: Container(),
          ),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text("Save"),
          ),
        ],
      );
}
