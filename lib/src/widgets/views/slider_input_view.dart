import 'package:flutter/material.dart';
import 'package:food_group_app/src/themes/app_themes.dart';

class RatingInputView extends StatefulWidget {
  /// The text to display above the center text of the page.
  ///
  /// This text will be bolded larger than the center text.
  final String? upperText;

  /// The text to display across the center of the page.
  final String centerText;

  /// The text to display under the main text in a smaller font.
  ///
  /// This would correspond to a hint text of some sort.
  final String? subText;

  /// The initial value for the slider.
  final double initialValue;

  /// A callback function when the slider changes value.
  final ValueChanged<double> onChangedValue;

  /// The text to display on the confirmation button on the right side.
  final String? confirmButtonText;

  /// The text to display on the decline button on the left side.
  final String? declineButtonText;

  /// A callback for when the confirm button is clicked.
  final VoidCallback? onConfirmButton;

  /// A callback for when the decline button is clicked.
  final VoidCallback? onDeclineButton;

  /// Whether to show values as integers rather than doubles.
  ///
  /// The value will still be stored as a double however will
  /// show as an integer on the UI.
  final bool showAsInteger;

  const RatingInputView({
    super.key,
    required this.centerText,
    required this.initialValue,
    required this.onChangedValue,
    this.confirmButtonText,
    this.declineButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
    this.showAsInteger = true,
    this.subText,
    this.upperText,
  });

  @override
  State<RatingInputView> createState() => _RatingInputViewState();
}

class _RatingInputViewState extends State<RatingInputView> {
  /// The currently selected value.
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.upperText != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.upperText!,
                        style: AppThemes.upperTextStyle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (widget.upperText != null)
                    const SizedBox(
                      height: 20,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.centerText,
                      style: AppThemes.centerTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (widget.subText != null)
                    const SizedBox(
                      height: 20,
                    ),
                  if (widget.subText != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.subText!,
                        style: AppThemes.subTextStyle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  Slider(
                    value: value,
                    onChanged: (value) {
                      setState(() => this.value = value);
                      widget.onChangedValue(value);
                    },
                    max: 10,
                    min: 1,
                    divisions: 9,
                    label: widget.showAsInteger ? '${value.toInt()}' : '$value',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.showAsInteger ? '${value.toInt()}' : '$value',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.declineButtonText != null &&
                    widget.onDeclineButton != null)
                  ElevatedButton(
                    style: widget.declineButtonText == null
                        ? ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            minimumSize: const Size(200, 40),
                          )
                        : null,
                    onPressed: widget.onDeclineButton,
                    child: Text(widget.declineButtonText!),
                  ),
                if (widget.declineButtonText != null &&
                    widget.confirmButtonText != null)
                  const SizedBox(
                    width: 64,
                  ),
                if (widget.confirmButtonText != null &&
                    widget.onConfirmButton != null)
                  FilledButton(
                    style: widget.declineButtonText == null
                        ? FilledButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            minimumSize: const Size(200, 40),
                          )
                        : null,
                    onPressed: widget.onConfirmButton,
                    child: Text(widget.confirmButtonText!),
                  ),
              ],
            ),
          )
        ],
      );
}
