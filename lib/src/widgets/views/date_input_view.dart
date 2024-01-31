import 'package:flutter/material.dart';
import 'package:food_group_app/src/themes/app_themes.dart';
import 'package:food_group_app/src/utils/datetime_helper.dart';
import 'package:food_group_app/src/widgets/views/base_view.dart';

class DateInputView extends StatefulWidget {
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
  final String initialValue;

  /// A callback function when the input changes value.
  final ValueChanged<String> onChangedValue;

  /// The text to display on the confirmation button on the right side.
  final String? confirmButtonText;

  /// The text to display on the decline button on the left side.
  final String? declineButtonText;

  /// A callback for when the confirm button is clicked.
  final VoidCallback? onConfirmButton;

  /// A callback for when the decline button is clicked.
  final VoidCallback? onDeclineButton;

  /// A validation function to run off the input.
  final String? Function(String?)? validator;

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

  const DateInputView({
    super.key,
    required this.centerText,
    required this.initialValue,
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
  });

  @override
  State<DateInputView> createState() => _DateInputViewState();
}

class _DateInputViewState extends State<DateInputView> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget buildDateInput() => FormField<String>(
        validator: widget.validator,
        key: widget.formKey,
        initialValue: widget.initialValue,
        builder: (formFieldState) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                label: Center(
                  child: Text(
                    widget.labelText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant, //todo
                  ),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                ),
                prefixIcon: const Icon(Icons.calendar_month),
                suffixIcon: _textController.text.isNotEmpty
                    ? Tooltip(
                        message: "Clear Date",
                        child: InkWell(
                          child: const Icon(Icons.close),
                          onTap: () {
                            setState(() => _textController.text = "");
                            formFieldState.didChange(_textController.text);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      )
                    : const SizedBox(width: 24),
                alignLabelWithHint: true,
                floatingLabelAlignment: FloatingLabelAlignment.center,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onTap: () => _selectDate(context, formFieldState),
              maxLines: 1,
              readOnly: true,
              onSubmitted: widget.onSubmit,
              textInputAction: widget.textInputAction,
              textAlign: TextAlign.center,
              onChanged: (value) {
                formFieldState.didChange(_textController.text);
                widget.onChangedValue(_textController.text);
              },
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
        inputWidget: buildDateInput(),
      );

  /// Handles logic for selecting a date in the date picker.
  Future<void> _selectDate(
      BuildContext context, FormFieldState<String> formFieldState) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: _textController.text.isNotEmpty
          ? DateTimeHelper.fromDate(_textController.text)
          : null,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (datePicked != null &&
        DateTimeHelper.toDate(datePicked) != _textController.text) {
      setState(() => _textController.text = DateTimeHelper.toDate(datePicked));
      formFieldState.didChange(_textController.text);
      widget.onChangedValue(_textController.text);
    }
    if (mounted) FocusScope.of(context).unfocus();
  }
}
