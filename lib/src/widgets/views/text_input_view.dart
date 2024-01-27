import 'package:flutter/material.dart';
import 'package:food_group_app/src/themes/app_themes.dart';

class TextInputView extends StatefulWidget {
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

  const TextInputView({
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
  State<TextInputView> createState() => _TextInputViewState();
}

class _TextInputViewState extends State<TextInputView> {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: FormField<String>(
                      key: widget.formKey,
                      validator: widget.validator,
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
                                ),
                              ),
                              alignLabelWithHint: true,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                            ),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            maxLines: 1,
                            textCapitalization: widget.textCapitalization,
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
                    ),
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
                if (widget.declineButtonText != null)
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
                if (widget.confirmButtonText != null)
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
