import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'themes/light_theme.dart';
import 'themes/dark_theme.dart';

import 'screens/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MBArtists',
      theme: lightTheme,
      darkTheme: lightTheme,
      initialRoute: '/home',
      getPages: [
        //Simple GetPage
        GetPage(name: '/home', page: () => HomeScreen(title: 'Accueil')),
      ],
    );
  }
}
