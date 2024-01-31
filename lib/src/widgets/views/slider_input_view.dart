import 'package:flutter/material.dart';
import 'package:food_group_app/src/themes/app_themes.dart';
import 'package:food_group_app/src/widgets/views/base_view.dart';

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

  Widget buildSliderInput() => Slider(
        value: value,
        onChanged: (value) {
          setState(() => this.value = value);
          widget.onChangedValue(value);
        },
        max: 10,
        min: 1,
        divisions: 9,
        label: widget.showAsInteger ? '${value.toInt()}' : '$value',
      );

  @override
  Widget build(BuildContext context) => BaseView(
        confirmButtonText: widget.confirmButtonText,
        declineButtonText: widget.declineButtonText,
        onConfirmButton: widget.onConfirmButton,
        onDeclineButton: widget.onDeclineButton,
        subText: widget.subText,
        upperText: widget.upperText,
        centerText: widget.centerText,
        inputWidget: buildSliderInput(),
      );
}
