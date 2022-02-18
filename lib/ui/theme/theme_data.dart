import 'package:flutter/material.dart';
import 'package:wallpaper/constants/constants.dart';

ThemeData getThemeData() {
  return ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: secondaryColor,
      ),
    ),
    scaffoldBackgroundColor: scaffoldColor,
    primaryColor: primaryColor,
    secondaryHeaderColor: secondaryColor,
    appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: primaryColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: textColor,
      selectionColor: textColor,
      selectionHandleColor: textColor,
    ),
  );
}
