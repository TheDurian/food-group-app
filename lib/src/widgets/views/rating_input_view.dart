import 'package:flutter/material.dart';

class RatingInputView extends StatefulWidget {
  /// The text to display across the center of the page.
  final String inputText;

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
    required this.inputText,
    required this.initialValue,
    required this.onChangedValue,
    this.confirmButtonText,
    this.declineButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
    this.showAsInteger = true,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              widget.inputText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.declineButtonText != null &&
                  widget.onDeclineButton != null)
                ElevatedButton(
                  onPressed: widget.onDeclineButton,
                  child: Text(widget.declineButtonText!),
                ),
              const SizedBox(
                width: 64,
              ),
              if (widget.confirmButtonText != null &&
                  widget.onConfirmButton != null)
                FilledButton(
                  onPressed: widget.onConfirmButton,
                  child: Text(widget.confirmButtonText!),
                ),
            ],
          )
        ],
      );
}
