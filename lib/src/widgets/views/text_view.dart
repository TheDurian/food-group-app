import 'package:flutter/material.dart';
import 'package:food_group_app/src/themes/app_themes.dart';

class TextView extends StatelessWidget {
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

  /// The text to display on the confirmation button on the right side.
  final String? confirmButtonText;

  /// The text to display on the decline button on the left side.
  final String? declineButtonText;

  /// A callback for when the confirm button is clicked.
  final VoidCallback? onConfirmButton;

  /// A callback for when the decline button is clicked.
  final VoidCallback? onDeclineButton;

  const TextView({
    super.key,
    required this.centerText,
    this.confirmButtonText,
    this.declineButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
    this.subText,
    this.upperText,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (upperText != null)
                      Text(
                        upperText!,
                        style: AppThemes.upperTextStyle(context),
                        textAlign: TextAlign.center,
                      ),
                    if (upperText != null)
                      const SizedBox(
                        height: 20,
                      ),
                    Text(
                      centerText,
                      style: AppThemes.centerTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                    if (subText != null)
                      const SizedBox(
                        height: 20,
                      ),
                    if (subText != null)
                      Text(
                        subText!,
                        style: AppThemes.subTextStyle(context),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (declineButtonText != null)
                  ElevatedButton(
                    style: declineButtonText == null
                        ? ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            minimumSize: const Size(200, 40),
                          )
                        : null,
                    onPressed: onDeclineButton,
                    child: Text(declineButtonText!),
                  ),
                if (declineButtonText != null && confirmButtonText != null)
                  const SizedBox(
                    width: 64,
                  ),
                if (confirmButtonText != null)
                  FilledButton(
                    style: declineButtonText == null
                        ? FilledButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            minimumSize: const Size(200, 40),
                          )
                        : null,
                    onPressed: onConfirmButton,
                    child: Text(confirmButtonText!),
                  ),
                const SizedBox(
                  height: 64,
                ),
              ],
            ),
          )
        ],
      );
}
