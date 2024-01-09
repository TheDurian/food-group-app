import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class ColorDialog extends StatefulWidget {
  /// The initial color.
  final Color? color;

  /// The text to display along the top of the dialog.
  final String titleText;

  const ColorDialog({
    super.key,
    this.color = Colors.transparent,
    this.titleText = "Select a Color",
  });

  @override
  State<ColorDialog> createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  /// The currently selected color.
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.titleText),
        content: WheelPicker(
          color: HSVColor.fromColor(selectedColor),
          showPalette: true,
          onChanged: (hsvColor) =>
              setState(() => selectedColor = hsvColor.toColor()),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, selectedColor.withOpacity(1)),
            child: const Text("Save"),
          ),
        ],
      );
}
