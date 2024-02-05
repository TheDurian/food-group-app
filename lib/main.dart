import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_group_app/src/routes/app_routes.dart';
import 'package:food_group_app/src/themes/app_themes.dart';
import 'package:food_group_app/src/config/globals.dart';
import 'package:food_group_app/src/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.getTheme(false),
      darkTheme: AppTheme.getTheme(true),
      themeMode: appTheme.getCurrentThemeMode(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      routes: AppRoutes.routes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
      initialRoute: AppRoutes.listRestaurants,
      debugShowCheckedModeBanner: false,
    );
  }
}
