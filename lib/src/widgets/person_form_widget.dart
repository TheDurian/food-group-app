import 'package:flutter/material.dart';

class PersonFormWidget extends StatelessWidget {
  final String? firstName;
  final String? lastName;

  final ValueChanged<String> onChangedFirstName;
  final ValueChanged<String> onChangedLastName;

  const PersonFormWidget({
    Key? key,
    this.firstName = '',
    this.lastName = '',
    required this.onChangedFirstName,
    required this.onChangedLastName,
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
}
