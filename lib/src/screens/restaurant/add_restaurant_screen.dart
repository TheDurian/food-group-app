import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/google/suggestion.dart';
import 'package:food_group_app/src/models/label.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/routes/arguments.dart';
import 'package:food_group_app/src/services/database/label_db.dart';
import 'package:food_group_app/src/services/database/person_db.dart';
import 'package:food_group_app/src/services/database/rating_db.dart';
import 'package:food_group_app/src/services/database/restaurant_db.dart';
import 'package:food_group_app/src/services/google/place_service.dart';
import 'package:food_group_app/src/utils/datetime_helper.dart';
import 'package:food_group_app/src/widgets/views/base_view.dart';
import 'package:food_group_app/src/widgets/views/date_input_view.dart';
import 'package:food_group_app/src/widgets/views/multi_select_input_view.dart';
import 'package:food_group_app/src/widgets/views/text_input_view.dart';
import 'package:location/location.dart';
import 'package:uuid/v4.dart';

class AddRestaurantScreen2 extends StatefulWidget {
  final Restaurant? restaurant;

  const AddRestaurantScreen2({super.key, required this.restaurant});

  @override
  State<AddRestaurantScreen2> createState() => _AddRestaurantScreen2State();
}

class _AddRestaurantScreen2State extends State<AddRestaurantScreen2> {
  late final PageController controller;
  final _formKeyName = GlobalKey<FormFieldState<String>>();
  final _formKeyDateVisited = GlobalKey<FormFieldState<String>>();

  String? placeAutocompleteQuery;
  late UuidV4 uuid;
  late LocationData _currentLocation;
  late List<Suggestion> _lastRestaurantOptions = <Suggestion>[];
  bool isLoading = false;

  late String restaurantName;
  late String address;
  late String dateVisited;
  late List<Label> labels;
  late List<Person> persons;

  Curve curve = Curves.ease;
  Duration duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    restaurantName = widget.restaurant?.name ?? '';
    address = widget.restaurant?.address ?? '';
    dateVisited = widget.restaurant?.dateVisited != null
        ? DateTimeHelper.toDate(widget.restaurant!.dateVisited)
        : '';
    labels = widget.restaurant?.labels ?? [];
    persons = widget.restaurant?.persons ?? [];
    uuid = const UuidV4();
    fetchLocation();
  }

  void fetchLocation() async {
    setState(() => isLoading = true);
    LocationData? location = await GooglePlaceService.getLocation();
    if (location != null) {
      setState(() => _currentLocation = location);
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _onWillPop();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _onWillPop,
              icon: const Icon(Icons.close),
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if (widget.restaurant == null)
                      BaseView(
                        centerText: 'Add a new restaurant',
                        confirmButtonText: 'Start',
                        onConfirmButton: () => controller.nextPage(
                          duration: duration,
                          curve: curve,
                        ),
                      ),
                    TextInputView<Suggestion>(
                        formKey: _formKeyName,
                        centerText: 'Where did you go?',
                        initialValue: restaurantName,
                        onChangedValue: (restaurantName) => setState(
                            () => this.restaurantName = restaurantName),
                        labelText: 'Name',
                        declineButtonText: 'Back',
                        onDeclineButton: () => controller.previousPage(
                              duration: duration,
                              curve: curve,
                            ),
                        confirmButtonText: 'Next',
                        onConfirmButton: () {
                          if (_formKeyName.currentState!.validate()) {
                            controller.nextPage(
                              duration: duration,
                              curve: curve,
                            );
                          }
                        },
                        validator: (name) => (name == null) || name.isEmpty
                            ? 'The name cannot be empty'
                            : null,
                        onSubmit: (value) {
                          if (_formKeyName.currentState!.validate()) {
                            controller.nextPage(
                              duration: duration,
                              curve: curve,
                            );
                          }
                        },
                        optionsBuilder: (textEditingValue) async {
                          placeAutocompleteQuery = textEditingValue.text;
                          if (textEditingValue.text.isEmpty) {
                            return [];
                          }

                          final List<Suggestion> options =
                              await GooglePlaceService.fetchSuggestions(
                            placeAutocompleteQuery!,
                            _currentLocation.latitude!,
                            _currentLocation.longitude!,
                            uuid.toString(),
                          );
                          if (placeAutocompleteQuery != textEditingValue.text) {
                            return _lastRestaurantOptions;
                          }
                          _lastRestaurantOptions = options;

                          return options;
                        },
                        displayStringForValue: (suggestion) => suggestion.name,
                        displayStringForOption: (suggestion) =>
                            suggestion.description),
                    DateInputView(
                      formKey: _formKeyDateVisited,
                      centerText: 'When did you go?',
                      initialValue: dateVisited,
                      onChangedValue: (dateVisited) =>
                          setState(() => this.dateVisited = dateVisited),
                      labelText: 'Date Visited',
                      declineButtonText: 'Back',
                      onDeclineButton: () => controller.previousPage(
                        duration: duration,
                        curve: curve,
                      ),
                      confirmButtonText: 'Next',
                      onConfirmButton: () {
                        if (_formKeyDateVisited.currentState!.validate()) {
                          controller.nextPage(
                            duration: duration,
                            curve: curve,
                          );
                        }
                      },
                      validator: (date) => (date == null) || date.isEmpty
                          ? 'The date visited cannot be empty'
                          : null,
                    ),
                    // TextInputView(
                    //   centerText: 'Where was it located?',
                    //   subText: 'Note: This field is optional!',
                    //   initialValue: address,
                    //   onChangedValue: (address) =>
                    //       setState(() => this.address = address),
                    //   labelText: 'Address',
                    //   declineButtonText: 'Back',
                    //   onDeclineButton: () => controller.previousPage(
                    //     duration: duration,
                    //     curve: curve,
                    //   ),
                    //   confirmButtonText: 'Next',
                    //   onConfirmButton: () {
                    //     controller.nextPage(
                    //       duration: duration,
                    //       curve: curve,
                    //     );
                    //   },
                    //   validator: (address) => (address == null) || address.isEmpty
                    //       ? 'The address cannot be empty'
                    //       : null,
                    //   onSubmit: (value) {
                    //     controller.nextPage(
                    //       duration: duration,
                    //       curve: curve,
                    //     );
                    //   },
                    // ),
                    MultiSelectInputView<Label>(
                      centerText: 'Would you like to add any labels?',
                      subText:
                          'New labels can be added at any time by clicking '
                          'on the input and selecting the add button on the top.',
                      initialItems: labels,
                      onChangedValue: (labels) =>
                          setState(() => this.labels = labels),
                      labelText: 'Select Labels',
                      buildSelectedItemText: (label) => label.label,
                      onAddClick: () async => await Navigator.pushNamed(
                        context,
                        AppRoutes.editLabel,
                      ),
                      refreshAllItems: LabelDatabase.readAllLabels,
                      titleText: 'Select Labels',
                      chipColor: (label) => label.color,
                      declineButtonText: 'Back',
                      onDeclineButton: () => controller.previousPage(
                        duration: duration,
                        curve: curve,
                      ),
                      confirmButtonText: 'Next',
                      onConfirmButton: () => controller.nextPage(
                        duration: duration,
                        curve: curve,
                      ),
                    ),
                    MultiSelectInputView<Person>(
                      centerText: 'Would you like to add any people?',
                      subText:
                          'New people can be added at any time by clicking '
                          'on the input and selecting the add button on the top.',
                      initialItems: persons,
                      onChangedValue: (persons) =>
                          setState(() => this.persons = persons),
                      labelText: 'Select People',
                      buildSelectedItemText: Person.fullNameFromPerson,
                      onAddClick: () async => await Navigator.pushNamed(
                        context,
                        AppRoutes.editPerson,
                      ),
                      refreshAllItems: PersonDatabase.readAllPersons,
                      titleText: 'Select People',
                      declineButtonText: 'Back',
                      onDeclineButton: () => controller.previousPage(
                        duration: duration,
                        curve: curve,
                      ),
                      onChipLongPress: (people) => Navigator.pushNamed(
                        context,
                        AppRoutes.editPerson,
                        arguments: people,
                      ),
                      labelAvatar: const Icon(Icons.person_2_outlined),
                      confirmButtonText: 'Next',
                      onConfirmButton: () {
                        controller.nextPage(
                          duration: duration,
                          curve: curve,
                        );
                      },
                    ),
                    BaseView(
                      centerText: widget.restaurant == null
                          ? 'Save restaurant and start rating?'
                          : 'Save restaurant?',
                      subText: widget.restaurant == null
                          ? 'Each person you add will have a chance to '
                              'provide their own ratings.\n\n'
                              'People will be selected in a random order.'
                          : null,
                      confirmButtonText: 'Save',
                      onConfirmButton: onSave,
                      declineButtonText: 'Back',
                      onDeclineButton: () => controller.previousPage(
                        duration: duration,
                        curve: curve,
                      ),
                    ),
                  ],
                ),
        ),
      );

  void _onWillPop() async => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Cancel submission?",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
          content: Text(
            "Any unsaved changes will be lost.",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );

  void onSave() async {
    Restaurant restaurant = widget.restaurant != null
        ? await updateRestaurant()
        : await addRestaurant();

    List<Rating> ratings = [];
    if (mounted) {
      await Navigator.pushNamed(
        context,
        AppRoutes.loader,
        arguments: 150,
      );
    }
    for (Person person in restaurant.persons!..shuffle()) {
      Rating? rating = await RatingDatabase.readRating(
        restaurant.id!,
        person.id!,
        raiseOnError: false,
      );
      if (mounted) {
        Rating? returnedRating = await Navigator.pushNamed<Rating>(
          context,
          AppRoutes.addRating,
          arguments: RatingScreenArguments(
            restaurant,
            person,
            rating,
          ),
        );
        if (returnedRating != null) ratings.add(returnedRating);
      }
    }

    if (mounted) {
      await Navigator.pushNamed(
        context,
        AppRoutes.loader,
        arguments: 0,
      );
    }
    if (mounted) {
      Navigator.popUntil(
        context,
        ModalRoute.withName(
          AppRoutes.home,
        ),
      );
    }
  }

  /// Updates the current restaurant in the database.
  Future<Restaurant> updateRestaurant() async {
    final restaurant = widget.restaurant!.copy(
      name: restaurantName,
      isChain: null, //todo
      address: address,
      dateVisited: DateTimeHelper.fromDate(dateVisited),
      dateModified: DateTime.now(),
      persons: persons,
      labels: labels,
    );
    await RestaurantDatabase.updateRestaurant(restaurant);
    return restaurant;
  }

  /// Adds a new restaurant to database.
  Future<Restaurant> addRestaurant() async {
    final dateAdded = DateTime.now();
    final restaurant = await RestaurantDatabase.createRestaurant(Restaurant(
      name: restaurantName,
      isChain: null, //todo
      address: address,
      dateVisited: DateTimeHelper.fromDate(dateVisited),
      dateAdded: dateAdded,
      dateModified: dateAdded,
      persons: persons,
      labels: labels,
    ));
    return restaurant;
  }
}
