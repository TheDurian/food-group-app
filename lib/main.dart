import 'package:flutter/material.dart';
import 'package:food_group_app/src/screens/restaurant/restaurants_screen.dart';
import 'package:food_group_app/src/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.getTheme(false), // TODO add saving theme selection
      home: const RestaurantScreen(),
    );
  }
}
