import 'package:flutter/material.dart';
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
);

final ThemeData lightTheme = ThemeData();
