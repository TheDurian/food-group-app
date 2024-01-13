import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/services/restaurant_db.dart';

class AddRestaurantOtherScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddRestaurantOtherScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<AddRestaurantOtherScreen> createState() =>
      _AddRestaurantOtherScreenState();
}

class _AddRestaurantOtherScreenState extends State<AddRestaurantOtherScreen> {
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
                    'And finally, select any additional notes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text(
                  "todo this will be a section with some checkboxes",
                ), //todo
                const SizedBox(
                  height: 20,
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
      );

  /// Handle logic when clicking the submit button or tapping next
  void onSubmit() async {
    // TODO temporary
    await RestaurantDatabase.createRestaurant(widget.restaurant.copy(
      isChain: false,
      dateAdded: DateTime.now(),
      dateModified: DateTime.now(),
    ));

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.restaurants));
  }
}
