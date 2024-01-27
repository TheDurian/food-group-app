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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildFirstName(context),
            const SizedBox(height: 16),
            buildLastName(context),
            const SizedBox(height: 32),
            buildSave(context),
          ],
        ),
      );

  /// Builds the first name input field
  Widget buildFirstName(BuildContext context) => TextFormField(
        maxLines: 1,
        initialValue: firstName,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
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
  Widget buildLastName(BuildContext context) => TextFormField(
        maxLines: 1,
        initialValue: lastName,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Last Name (Optional)',
          labelText: 'Last Name (Optional)',
        ),
        onChanged: onChangedLastName,
        textInputAction: TextInputAction.next,
      );

  /// Builds the save button.
  Widget buildSave(BuildContext context) => SizedBox(
        width: double.maxFinite,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Theme.of(context).hoverColor,
          ),
          onPressed: onSubmit,
          child: const Text("Save"),
        ),
      );
}
