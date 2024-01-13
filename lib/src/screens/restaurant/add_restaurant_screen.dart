import 'package:flutter/material.dart';
import 'package:food_group_app/src/models/restaurant.dart';
import 'package:food_group_app/src/routes/app_routes.dart';

class AddRestaurantScreen extends StatelessWidget {
  const AddRestaurantScreen({super.key});

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       appBar: AppBar(),
  //       body: Center(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           verticalDirection: VerticalDirection.down,
  //           children: [
  //             const Flexible(
  //               flex: 7,
  //               fit: FlexFit.tight,
  //               child: Hero(
  //                 tag: 'restaurantIcon',
  //                 child: Icon(Icons.food_bank_outlined, size: 300),
  //               ),
  //             ),
  //             const Flexible(
  //               flex: 4,
  //               child: Text(
  //                 "Add a new restaurant",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //             const Padding(padding: EdgeInsets.all(10)),
  //             const SizedBox(
  //               width: 300,
  //               child: Padding(
  //                 padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
  //                 child: Text(
  //                   "You will be a asked a couple questions about the "
  //                   "restaurant and your overall experience. Don't forget "
  //                   "that you can always edit your answers later."
  //                   "\n\nEnjoy!",
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //             ),
  //             const Padding(padding: EdgeInsets.all(10)),
  //             Flexible(
  //               flex: 1,
  //               child: FilledButton(
  //                 onPressed: () => Navigator.pushNamed(
  //                   context,
  //                   AppRoutes.addRestaurantName,
  //                   arguments: const Restaurant(),
  //                 ),
  //                 child: const Text("Let's Start!"),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Hero(
                  tag: 'restaurantIcon',
                  child: Icon(Icons.food_bank_outlined, size: 300),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Add a new restaurant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // TODO maybe add a small description or info text around here?
                // SizedBox(
                //   width: 300,
                //   child: Padding(
                //     padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                //     child: Text(
                //       "You will be a asked a couple questions about the "
                //       "restaurant and your overall experience. Don't forget "
                //       "that you can always edit your answers later."
                //       "\n\nEnjoy!",
                //       style: TextStyle(
                //         fontSize: 16,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.addRestaurantName,
                    arguments: const Restaurant(),
                  ),
                  child: const Text("Let's Start!"),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      );
}
