import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';

class AddRestaurantAddressScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddRestaurantAddressScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<AddRestaurantAddressScreen> createState() =>
      _AddRestaurantAddressScreenState();
}

class _AddRestaurantAddressScreenState
    extends State<AddRestaurantAddressScreen> {
  late TextEditingController _textController;
  late String buttonText;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.restaurant.address ?? '',
    );
    buttonText = _setButtonText();
  }

  /// Update button text to say skip or continue.
  String _setButtonText() {
    return _textController.text.isEmpty ? 'Skip' : 'Continue';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Hero(
                  tag: 'restaurantIcon',
                  child: Icon(Icons.food_bank_outlined, size: 100),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'What is the address of the restaurant you went to?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Note:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ' This step is optional',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      alignLabelWithHint: true,
                      // TODO: change label text to be centered?
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                    ),
                    maxLines: 1,
                    onChanged: (value) => setState(() {
                      _textController.text = value;
                      buttonText = _setButtonText();
                    }),
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (text) => onSubmit(),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 180,
                  child: FilledButton.tonal(
                    onPressed: onSubmit,
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Handle logic when clicking the submit button or tapping next
  void onSubmit() => Navigator.pushNamed(
        context,
        AppRoutes.addRestaurantDate,
        arguments: widget.restaurant.copy(address: _textController.text.trim()),
      );
}
