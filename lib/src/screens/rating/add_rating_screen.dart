import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/person.dart';
import 'package:food_group_app/src/models/rating.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/rating_db.dart';
import 'package:food_group_app/src/widgets/views/star_input_view.dart';
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
    tasteRating = widget.rating?.tasteRating ?? 2.5;
    serviceRating = widget.rating?.serviceRating ?? 2.5;
    ambianceRating = widget.rating?.ambianceRating ?? 2.5;
    presentationRating = widget.rating?.presentationRating ?? 2.5;
    costWorthRating = widget.rating?.costWorthRating ?? 2.5;
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
          body: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              TextView(
                upperText: widget.person.fullName(),
                centerText: 'Get ready to give your ratings!',
                subText: 'You will be asked a couple questions about your '
                    'meal and time at this restaurant.',
                confirmButtonText: "Next",
                declineButtonText: "Skip",
                onConfirmButton: () => controller.nextPage(
                  duration: duration,
                  curve: curve,
                ),
                onDeclineButton: () => _onWillPop(),
              ),
              StarInputView(
                initialValue: tasteRating,
                centerText: 'How good did this meal taste?',
                subText: 'Would you order the same meal again?\n'
                    'Were the flavors to your liking?',
                onChangedValue: (value) => setState(() => tasteRating = value),
                showAsInteger: false,
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
              StarInputView(
                initialValue: serviceRating,
                centerText: 'How was the service?',
                subText: 'Did the staff treat you well?\n'
                    'Were your drinks or chips refilled often?',
                onChangedValue: (value) =>
                    setState(() => serviceRating = value),
                showAsInteger: false,
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
              StarInputView(
                initialValue: ambianceRating,
                centerText: 'How was the ambiance?',
                subText: 'Was there a fun or unique theme?\n'
                    'Was the atmosphere to your liking?',
                onChangedValue: (value) =>
                    setState(() => ambianceRating = value),
                showAsInteger: false,
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
              StarInputView(
                initialValue: presentationRating,
                centerText: 'How was the presentation of your food?',
                subText: 'Was there thought put into the way your food '
                    'was presented on your plate?\n'
                    'Were you expecting it to?',
                onChangedValue: (value) =>
                    setState(() => presentationRating = value),
                showAsInteger: false,
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
              StarInputView(
                initialValue: costWorthRating,
                centerText: 'Was your money well spent?',
                subText: 'Do you think you got a good deal for '
                    'what you were served?\nDo you think you overpaid?',
                onChangedValue: (value) =>
                    setState(() => costWorthRating = value),
                showAsInteger: false,
                confirmButtonText: "Next",
                declineButtonText: "Back",
                onConfirmButton: onSubmit,
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
          title: const Text("Skip rating?"),
          content: const Text("Exiting now will skip your turn to rate. "
              "A rating can always be added through the edit screen later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No, cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes, skip'),
            ),
          ],
        ),
      );

  void onSubmit() async {
    Rating rating = await addOrUpdateRestaurant();
    Navigator.pop(context, rating);
  }

  /// Attempts to add or update the restaurant.
  Future<Rating> addOrUpdateRestaurant() async {
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
