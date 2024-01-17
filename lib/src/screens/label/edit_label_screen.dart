import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/services/label_db.dart';
import 'package:food_group_app/src/utils/datetime_helper.dart';
import 'package:food_group_app/src/widgets/forms/label_form_widget.dart';

class AddEditLabelScreen extends StatefulWidget {
  /// A label to prefill data on the edit screen.
  final Label? label;

  const AddEditLabelScreen({
    super.key,
    this.label,
  });

  @override
  State<AddEditLabelScreen> createState() => _AddEditLabelScreenState();
}

class _AddEditLabelScreenState extends State<AddEditLabelScreen> {
  /// Form key to keep current form state;
  final _formKey = GlobalKey<FormState>();

  /// The name of a label;
  late String labelName;

  /// The color for this label;
  late Color color;

  @override
  void initState() {
    super.initState();

    labelName = widget.label?.label ?? '';
    color = widget.label?.color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(labelName),
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: LabelFormWidget(
                labelName: labelName,
                color: color,
                onChangedLabelName: (labelName) =>
                    setState(() => this.labelName = labelName),
                onChangedColor: (color) => setState(() => this.color = color),
                onSubmit: _addOrUpdateLabel,
              ),
            ),
            if (widget.label != null) ...showOnEditInfo(),
          ],
        ),
      );

  /// Show optional fields when editing.
  List<Widget> showOnEditInfo() => [
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        ),
        Text(
          "Label Added: "
          "${DateTimeHelper.toDateAndTime(widget.label!.dateAdded!)}",
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          "Label Modified: "
          "${DateTimeHelper.toDateAndTime(widget.label!.dateModified!)}",
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
        )
      ];

  /// Attempts to add or update the label.
  void _addOrUpdateLabel() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.label != null;

      Label dbLabel;
      if (isUpdating) {
        dbLabel = await updateLabel();
      } else {
        dbLabel = await addLabel();
      }
      Navigator.pop(context, dbLabel);
    }
  }

  /// Updates the current label in the database.
  Future<Label> updateLabel() async {
    final label = widget.label!.copy(
      label: labelName,
      color: color,
      dateModified: DateTime.now(),
    );
    return await LabelDatabase.updateLabel(label);
  }

  /// Adds a new label to database.
  Future<Label> addLabel() async {
    final dateAdded = DateTime.now();
    final label = Label(
      label: labelName,
      color: color,
      dateAdded: dateAdded,
      dateModified: dateAdded,
    );
    return await LabelDatabase.createLabel(label);
  }
}
