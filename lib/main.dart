import 'package:bi_suru_app/providers/bottom_nav_bar_provider.dart';
import 'package:bi_suru_app/providers/places_provider.dart';
import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/providers/user_provider.dart';
import 'package:bi_suru_app/screens/Splash/splash_screen.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await openHiveBoxes();
  runApp(const MyApp());
}

Future<void> openHiveBoxes() async {
  await Hive.openBox('system');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (context) => SystemProvider()),
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
      ],
      child: MaterialApp(
        title: 'Bi Sürü',
        theme: ThemeData(
          fontFamily: 'ReadexPro',
          primaryColor: MyColors.red,
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: MyColors.grey,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
