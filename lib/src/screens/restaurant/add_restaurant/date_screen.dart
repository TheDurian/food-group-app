import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/utils/datetime_helper.dart';

class AddRestaurantDateScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddRestaurantDateScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<AddRestaurantDateScreen> createState() =>
      _AddRestaurantDateScreenState();
}

class _AddRestaurantDateScreenState extends State<AddRestaurantDateScreen> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.restaurant.dateVisited != null
          ? DateTimeHelper.toDate(widget.restaurant.dateVisited!)
          : '',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      'When did you go?',
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
                      validator: (dateVisited) {
                        return (dateVisited == null) || dateVisited.isEmpty
                            ? 'The date visited cannot be empty'
                            : null;
                      },
                      builder: (formFieldState) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              labelText: 'Date Visited',
                              focusedBorder: const UnderlineInputBorder(),
                              floatingLabelStyle: const TextStyle(
                                  color: Colors.black), //TODO const color
                              prefixIcon: const Icon(Icons.calendar_month),
                              suffixIcon: _textController.text.isNotEmpty
                                  ? Tooltip(
                                      message: "Clear Date",
                                      child: InkWell(
                                        child: const Icon(Icons.close),
                                        onTap: () {
                                          setState(
                                              () => _textController.text = "");
                                          formFieldState
                                              .didChange(_textController.text);
                                        },
                                      ),
                                    )
                                  : null,
                              alignLabelWithHint: true,
                              // TODO: change label text to be centered?
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                            ),
                            onTap: () => _selectDate(context, formFieldState),
                            maxLines: 1,
                            readOnly: true,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (text) => onSubmit(),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            onChanged: (dateVisited) =>
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
                ],
              ),
            ),
          ),
        ),
      );

  /// Handles logic for selecting a date in the date picker.
  Future<void> _selectDate(
      BuildContext context, FormFieldState<String> formFieldState) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (datePicked != null && datePicked != widget.restaurant.dateVisited) {
      setState(() => _textController.text = DateTimeHelper.toDate(datePicked));
      formFieldState.didChange(_textController.text);
    }
  }

  /// Handle logic when clicking the submit button
  void onSubmit() => _formKey.currentState!.validate()
      ? Navigator.pushNamed(
          context,
          AppRoutes.addRestaurantLabels,
          arguments: widget.restaurant.copy(
            dateVisited: DateTimeHelper.fromDate(_textController.text.trim()),
          ),
        )
      : null;
}
