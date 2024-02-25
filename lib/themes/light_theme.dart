import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ctrl/getCTRL.dart';

final ctrl = Get.put(ControllerApp());

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Regular',
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(ctrl.primaryColor),
      elevation: 0
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'Bold',
        color: Color(ctrl.primaryColor)
      ),
      displayMedium: TextStyle(
          fontFamily: 'Bold',
          color: Color(ctrl.primaryColor)
      ),
      displaySmall: TextStyle(
          fontFamily: 'Bold'
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Bold',
          color: Color(ctrl.primaryColor)
      ),
      headlineMedium: TextStyle(
          fontFamily: 'Bold',
          color: Color(ctrl.primaryColor)
      ),
      headlineSmall: TextStyle(
          fontFamily: 'Bold'
      ),
      titleLarge: TextStyle(
        fontFamily: 'Bold',
          color: Color(ctrl.primaryColor)
      ),
      titleMedium: TextStyle(
          fontFamily: 'Bold',
          color: Color(ctrl.primaryColor)
      ),
      titleSmall: TextStyle(
          fontFamily: 'Bold'
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateTextStyle.resolveWith((states) => TextStyle(
          fontFamily: 'Bold',
          fontSize: 22,
        )),
        minimumSize: MaterialStateProperty.all(Size.fromHeight(65)),
      )
    ),
    colorScheme: ColorScheme.light(
        background: Colors.white,
        primary: Color(ctrl.primaryColor),
        secondary: Color(ctrl.secondaryColor)
    ),
);