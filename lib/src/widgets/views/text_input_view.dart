import 'package:flutter/material.dart';
import 'package:food_group_app/src/widgets/views/base_view.dart';

class TextInputView<T extends Object> extends StatefulWidget {
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

  /// The initial value for the input.
  final T initialValue;

  /// A function to convert the initial value to a string.
  final String Function(T) initialValueToString;

  /// A callback function when the input changes value.
  final ValueChanged<T> onChangedValue;

  /// The text to display on the confirmation button on the right side.
  final String? confirmButtonText;

  /// The text to display on the decline button on the left side.
  final String? declineButtonText;

  /// A callback for when the confirm button is clicked.
  final VoidCallback? onConfirmButton;

  /// A callback for when the decline button is clicked.
  final VoidCallback? onDeclineButton;

  /// A validation function to run off the input.
  final String? Function(T?)? validator;

  /// The text to display as a label on the input field.
  final String labelText;

  /// The capitalization to use for the input.
  final TextCapitalization textCapitalization;

  /// A function to call on submit of the keyboard.
  final void Function(String)? onSubmit;

  /// The text keyboard submit action / word.
  final TextInputAction textInputAction;

  /// A key to use for validation of the form.
  final Key? formKey;

  /// A function which returns autofill options based on the current input
  final Future<List<T>> Function(TextEditingValue) optionsBuilder;

  /// A function which converts an option to the string it should display
  final String Function(T) displayStringForOption;

  /// A function which converts a selection to how it should display on field
  final String Function(T) displayStringForValue;

  const TextInputView({
    super.key,
    required this.centerText,
    required this.initialValue,
    required this.initialValueToString,
    required this.onChangedValue,
    this.confirmButtonText,
    this.declineButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
    this.validator,
    required this.labelText,
    this.textCapitalization = TextCapitalization.words,
    this.onSubmit,
    this.textInputAction = TextInputAction.next,
    this.formKey,
    this.subText,
    this.upperText,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.displayStringForValue,
  });

  @override
  State<TextInputView<T>> createState() => _TextInputViewState();
}

class _TextInputViewState<T extends Object> extends State<TextInputView<T>> {
  /// A controller for the text input.
  late TextEditingController _textController;

  /// The current focus node.
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialValueToString(widget.initialValue),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Builds the autocomplete options menu items.
  Widget buildAutocompleteOptions(
    Iterable<T> options,
    void Function(T) onSelected,
  ) =>
      Material(
        elevation: 10.0,
        child: Scrollbar(
          child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                    title: Text(
                      widget.displayStringForOption(
                        options.elementAt(index),
                      ),
                    ),
                    onTap: () => onSelected(
                      options.elementAt(index),
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: options.length),
        ),
      );

  /// Builds the central text form field.
  Widget buildTextFormField() => FormField<T>(
        key: widget.formKey,
        validator: widget.validator,
        initialValue: widget.initialValue,
        builder: (formFieldState) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => RawAutocomplete<T>(
                onSelected: (value) {
                  widget.onChangedValue(value);
                  formFieldState.didChange(value);
                },
                focusNode: _focusNode,
                textEditingController: _textController,
                optionsBuilder: widget.optionsBuilder,
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) =>
                    TextField(
                  focusNode: _focusNode,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    label: Center(
                      child: Text(
                        widget.labelText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignLabelWithHint: true,
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 1,
                  textCapitalization: widget.textCapitalization,
                  onSubmitted: widget.onSubmit,
                  textInputAction: widget.textInputAction,
                  textAlign: TextAlign.center,
                  // onChanged: (value) {
                  //   formFieldState.didChange(value);
                  //   widget.onChangedValue(value);
                  // },
                ),
                optionsViewBuilder: (
                  context,
                  onSelected,
                  options,
                ) =>
                    Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 200,
                    child: buildAutocompleteOptions(options, onSelected),
                  ),
                ),
                displayStringForOption: widget.displayStringForValue,
              ),
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              )
          ],
        ),
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
        inputWidget: buildTextFormField(),
      );
}
