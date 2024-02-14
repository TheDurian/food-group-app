import 'package:flutter/material.dart';
import 'package:food_group_app/src/utils/extensions.dart';
import 'package:food_group_app/src/widgets/dialogs/color_dialog.dart';

class ColorInput extends StatefulWidget {
  /// The label for this input.
  final String inputLabel;

  /// The initial color.
  final Color? color;

  /// A function to call when the color has changed.
  final ValueChanged<Color> onChangedColor;

  const ColorInput({
    super.key,
    required this.inputLabel,
    this.color = Colors.transparent,
    required this.onChangedColor,
  });

  @override
  State<ColorInput> createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput> {
  /// The currently selected color.
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(64, 0, 64, 0),
        child: Row(
          children: [
            Text(widget.inputLabel),
            Expanded(child: Container()),
            SizedBox(
              height: 32,
              width: 64,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colorScheme.outline),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: selectedColor,
                  ),
                ),
                onTap: () async {
                  var color = await showDialog<Color>(
                    context: context,
                    builder: (BuildContext context) => ColorDialog(
                      color: selectedColor,
                    ),
                  );
                  if (color != null) {
                    widget.onChangedColor(color);
                    setState(() => selectedColor = color);
                  }
                },
              ),
            ),
          ],
        ),
      );
}
