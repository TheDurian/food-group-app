import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';

class AddRestaurantNameScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddRestaurantNameScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<AddRestaurantNameScreen> createState() =>
      _AddRestaurantNameScreenState();
}

class _AddRestaurantNameScreenState extends State<AddRestaurantNameScreen> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.restaurant.name ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Center(
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
                      'What is the name of the restaurant you went to?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: FormField<String>(
                      validator: (name) {
                        return (name == null) || name.isEmpty
                            ? 'The name cannot be empty'
                            : null;
                      },
                      builder: (formFieldState) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              alignLabelWithHint: true,
                              // TODO: change label text to be centered?
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                            ),
                            maxLines: 1,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (text) => onSubmit(),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            onChanged: (name) =>
                                formFieldState.didChange(_textController.text),
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
                    height: 20,
                  ),
                  SizedBox(
                    width: 180,
                    child: FilledButton.tonal(
                      onPressed: onSubmit,
                      child: const Text("Continue"),
                    ),
                  ),
                  // Maybe add back this empty space at the end
                  // const SizedBox(
                  //   height: 40,
                  // ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Handle logic when clicking the submit button or tapping next
  void onSubmit() => _formKey.currentState!.validate()
      ? Navigator.pushNamed(
          context,
          AppRoutes.addRestaurantAddress,
          arguments: widget.restaurant.copy(name: _textController.text.trim()),
        )
      : null;
}
