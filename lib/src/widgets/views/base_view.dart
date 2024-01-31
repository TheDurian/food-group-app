import 'package:flutter/material.dart';
import 'package:food_group_app/src/themes/app_themes.dart';

class BaseView extends StatelessWidget {
  final String? upperText;
  final String centerText;
  final String? subText;
  final String? declineButtonText;
  final String? confirmButtonText;
  final VoidCallback? onConfirmButton;
  final VoidCallback? onDeclineButton;
  final Widget? inputWidget;

  const BaseView({
    super.key,
    this.upperText,
    required this.centerText,
    this.subText,
    this.declineButtonText,
    this.confirmButtonText,
    this.onConfirmButton,
    this.onDeclineButton,
    this.inputWidget,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (upperText != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        upperText!,
                        style: AppThemes.upperTextStyle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (upperText != null)
                    const SizedBox(
                      height: 20,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      centerText,
                      style: AppThemes.centerTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (subText != null)
                    const SizedBox(
                      height: 20,
                    ),
                  if (subText != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        subText!,
                        style: AppThemes.subTextStyle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: inputWidget,
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
            child: Align(
              alignment: Alignment.topCenter,
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
                ],
              ),
            ),
          )
        ],
      );
}
