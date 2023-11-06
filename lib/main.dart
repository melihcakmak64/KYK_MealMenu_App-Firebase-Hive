import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kyk_menu/constants/constants.dart';
import 'package:kyk_menu/firebase_options.dart';

import 'package:kyk_menu/views/pages/MenuPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);
  await Hive.initFlutter();
  await Hive.openBox("local");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kyk Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellowAccent, onSurface: Colors.white),
        scaffoldBackgroundColor: MyColors.backgroundColor,
        datePickerTheme: DatePickerThemeData(
          headerForegroundColor: Colors.white,
          backgroundColor: Color.fromARGB(193, 48, 1, 49),
        ),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}
