import 'package:flutter/material.dart';
import 'package:food_group_app/src/widgets/inputs/color_input_widget.dart';

class LabelFormWidget extends StatelessWidget {
  /// The name of a label.
  final String? labelName;

  /// The color for this label.
  final Color? color;

  /// A function to call when the label name has changed.
  final ValueChanged<String> onChangedLabelName;

  /// A function to call when the label color has changed.
  final ValueChanged<Color> onChangedColor;

  /// A function to call when the submit button is clicked.
  final VoidCallback onSubmit;

  const LabelFormWidget({
    super.key,
    this.labelName = '',
    this.color = Colors.transparent,
    required this.onChangedLabelName,
    required this.onChangedColor,
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
              buildColorPicker(),
              const SizedBox(height: 32),
              buildSave(),
            ],
          ),
        ),
      );

  /// Builds the label name input field.
  Widget buildFirstName() => TextFormField(
        maxLines: 1,
        initialValue: labelName,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Label Name',
          labelText: 'Label Name',
        ),
        validator: (labelName) => labelName != null && labelName.isEmpty
            ? 'The label name cannot be empty'
            : null,
        onChanged: onChangedLabelName,
        textInputAction: TextInputAction.next,
      );

  /// Builds the color input field.
  Widget buildColorPicker() => ColorInput(
        inputLabel: 'Label Color:',
        color: color,
        onChangedColor: onChangedColor,
      );

  /// Builds the save button.
  Widget buildSave() => Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: onSubmit,
          child: const Text("Save"),
        ),
      );
}
