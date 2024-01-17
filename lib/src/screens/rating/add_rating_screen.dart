import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/rating_db.dart';
import 'package:food_group_app/src/widgets/views/rating_input_view.dart';
import 'package:food_group_app/src/widgets/views/text_view.dart';

class AddRatingScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Person person;
  final Rating? rating;

  const AddRatingScreen({
    super.key,
    required this.restaurant,
    required this.person,
    required this.rating,
  });

  @override
  State<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends State<AddRatingScreen> {
  late final PageController controller;
  late double tasteRating;
  late double serviceRating;
  late double ambianceRating;
  late double presentationRating;
  late double costWorthRating;

  Curve curve = Curves.ease;
  Duration duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    tasteRating = widget.rating?.tasteRating ?? 5;
    serviceRating = widget.rating?.serviceRating ?? 5;
    ambianceRating = widget.rating?.ambianceRating ?? 5;
    presentationRating = widget.rating?.presentationRating ?? 5;
    costWorthRating = widget.rating?.costWorthRating ?? 5;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TextView(
              inputText: '${widget.person.fullName()}'
                  '\nGet ready to give your ratings!',
              confirmButtonText: "Next",
              declineButtonText: "Exit",
              onConfirmButton: () => controller.nextPage(
                duration: duration,
                curve: curve,
              ),
              onDeclineButton: () => Navigator.popUntil(
                context,
                ModalRoute.withName(AppRoutes.addRestaurantOther),
              ),
            ),
            RatingInputView(
              inputText: 'On a scale of 1 to 10, how good '
                  'did this meal taste?',
              initialValue: tasteRating,
              onChangedValue: (value) => setState(() => tasteRating = value),
              confirmButtonText: "Next",
              declineButtonText: "Back",
              onConfirmButton: () => controller.nextPage(
                duration: duration,
                curve: curve,
              ),
              onDeclineButton: () => controller.previousPage(
                duration: duration,
                curve: curve,
              ),
            ),
            RatingInputView(
              inputText: 'On a scale of 1 to 10, how was the service?',
              initialValue: serviceRating,
              onChangedValue: (value) => setState(() => serviceRating = value),
              confirmButtonText: "Next",
              declineButtonText: "Back",
              onConfirmButton: () => controller.nextPage(
                duration: duration,
                curve: curve,
              ),
              onDeclineButton: () => controller.previousPage(
                duration: duration,
                curve: curve,
              ),
            ),
            RatingInputView(
              inputText: 'On a scale of 1 to 10, how was the ambiance?',
              initialValue: ambianceRating,
              onChangedValue: (value) => setState(() => ambianceRating = value),
              confirmButtonText: "Next",
              declineButtonText: "Back",
              onConfirmButton: () => controller.nextPage(
                duration: duration,
                curve: curve,
              ),
              onDeclineButton: () => controller.previousPage(
                duration: duration,
                curve: curve,
              ),
            ),
            RatingInputView(
              inputText: 'On a scale of 1 to 10, how was the '
                  'presentation of your food?',
              initialValue: presentationRating,
              onChangedValue: (value) =>
                  setState(() => presentationRating = value),
              confirmButtonText: "Next",
              declineButtonText: "Back",
              onConfirmButton: () => controller.nextPage(
                duration: duration,
                curve: curve,
              ),
              onDeclineButton: () => controller.previousPage(
                duration: duration,
                curve: curve,
              ),
            ),
            RatingInputView(
              inputText: 'On a scale of 1 to 10, how would you say your meal '
                  'felt worth of the amount you paid?',
              initialValue: costWorthRating,
              onChangedValue: (value) =>
                  setState(() => costWorthRating = value),
              confirmButtonText: "Submit",
              declineButtonText: "Back",
              onConfirmButton: onSubmit,
              onDeclineButton: () => controller.previousPage(
                duration: duration,
                curve: curve,
              ),
            ),
          ],
        ),
      );

  void onSubmit() async {
    Rating rating = await _addOrUpdateRestaurant();
    Navigator.pop(context, rating);
  }

  /// Attempts to add or update the restaurant.
  Future<Rating> _addOrUpdateRestaurant() async {
    final isUpdating = widget.rating != null;
    Rating rating;
    if (isUpdating) {
      rating = await updateRating();
    } else {
      rating = await addRating();
    }
    return rating;
  }

  /// Updates the current rating in the database.
  Future<Rating> updateRating() async {
    final rating = widget.rating!.copy(
      tasteRating: tasteRating,
      serviceRating: serviceRating,
      ambianceRating: ambianceRating,
      presentationRating: presentationRating,
      costWorthRating: costWorthRating,
      dateModified: DateTime.now(),
    );
    return await RatingDatabase.updateRating(rating);
  }

  /// Adds a new rating to the database.
  Future<Rating> addRating() async {
    final dateAdded = DateTime.now();
    final rating = Rating(
      personId: widget.person.id!,
      restaurantId: widget.restaurant.id!,
      tasteRating: tasteRating,
      serviceRating: serviceRating,
      ambianceRating: ambianceRating,
      presentationRating: presentationRating,
      costWorthRating: costWorthRating,
      dateModified: dateAdded,
      dateAdded: dateAdded,
    );
    return await RatingDatabase.createRating(rating);
  }
}
