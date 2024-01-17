import 'package:flutter/material.dart';
import 'package:food_group_app/src/widgets/inputs/multi_select_input_widget.dart';

class MultiSelectInputView<T> extends StatefulWidget {
  /// The text to display across the center of the page.
  final String inputText;

  /// A list of currently selected items
  final List<T> initialItems;

  /// A callback function when the selected items have changed.
  final ValueChanged<List<T>> onChangedValue;

  /// The text to display on the confirmation button on the right side.
  final String? confirmButtonText;

  /// The text to display on the decline button on the left side.
  final String? declineButtonText;

  /// A callback for when the confirm button is clicked.
  final VoidCallback? onConfirmButton;

  /// A callback for when the decline button is clicked.
  final VoidCallback? onDeclineButton;

  /// A validation function to run off the input.
  final String? Function(List<T>?)? validator;

  /// The text to display as a label on the input field.
  final String labelText;

  /// A function to call on submit of the keyboard.
  final void Function(String)? onSubmit;

  /// A key to use for validation of the form.
  final Key? formKey;

  /// Creates the text to display for each item and chip.
  final String Function(T) buildSelectedItemText;

  /// A function to handle clicking on the add icon.
  final Future<void> Function() onAddClick;

  /// A function to be called to regenerate all existing items of type T.
  final Future<List<T>> Function() refreshAllItems;

  /// The text to display along the top of the dialog.
  final String titleText;

  /// A function that navigates to an edit page for an item.
  ///
  /// The function should return the newly edited item.
  final Future<T?> Function(T)? onChipLongPress;

  /// A function to be called to get the color for each chip.
  ///
  /// If no function is specified, no background color will be set.
  final Color? Function(T)? chipColor;

  /// A widget to display on the left side of each label.
  final Widget? labelAvatar;

  const MultiSelectInputView({
    super.key,
    required this.inputText,
    required this.initialItems,
    required this.onChangedValue,
    this.confirmButtonText,
    this.declineButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
    this.validator,
    required this.labelText,
    this.onSubmit,
    this.formKey,
    required this.buildSelectedItemText,
    required this.onAddClick,
    required this.refreshAllItems,
    required this.titleText,
    this.onChipLongPress,
    this.chipColor,
    this.labelAvatar,
  });

  @override
  State<MultiSelectInputView<T>> createState() => _MultiSelectInputViewState();
}

class _MultiSelectInputViewState<T> extends State<MultiSelectInputView<T>> {
  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = widget.initialItems;
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: FormField<List<T>>(
              key: widget.formKey,
              validator: widget.validator,
              initialValue: widget.initialItems,
              builder: (formFieldState) => Column(
                children: [
                  MultiSelectInput<T>(
                    chipAlignment: Alignment.centerLeft,
                    labelAvatar: widget.labelAvatar,
                    inputHintText: widget.labelText,
                    selectedItems: selectedItems,
                    onChangedSelectedItems: (items) {
                      setState(() => selectedItems = items);
                      widget.onChangedValue(items);
                      formFieldState.didChange(items);
                    },
                    buildSelectedItemText: widget.buildSelectedItemText,
                    titleText: widget.titleText,
                    onAddClick: widget.onAddClick,
                    refreshAllItems: widget.refreshAllItems,
                    onChipLongPress: widget.onChipLongPress,
                    chipColor: widget.chipColor,
                    inputDecoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                      ),
                    ),
                  ),
                  if (formFieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        formFieldState.errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                ],
              ),
            ),
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
