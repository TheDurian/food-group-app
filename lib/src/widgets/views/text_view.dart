import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  /// The text to display across the center of the page.
  final String inputText;

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
    required this.inputText,
    this.confirmButtonText,
    this.declineButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              inputText,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (declineButtonText != null && onDeclineButton != null)
                ElevatedButton(
                  onPressed: onDeclineButton,
                  child: Text(declineButtonText!),
                ),
              const SizedBox(
                width: 64,
              ),
              if (confirmButtonText != null && onConfirmButton != null)
                FilledButton(
                  onPressed: onConfirmButton,
                  child: Text(confirmButtonText!),
                ),
            ],
          )
        ],
      );
}
