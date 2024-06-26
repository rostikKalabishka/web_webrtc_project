import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webrtc_flutter/ui/theme/const_color.dart';

final darkTheme = ThemeData(
  primaryColor: ConstColor.primaryColor,
  cardColor: ConstColor.cardColor,
  brightness: Brightness.dark,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: ConstColor.textFieldBorderSideColor),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 18),
  ),
);

final ThemeData lightTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 202, 7, 7),
  cardColor: Colors.grey.withOpacity(0.2),
  brightness: Brightness.light,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 18),
  ),
);
