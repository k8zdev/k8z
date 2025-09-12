import 'package:flutter/material.dart';

const double smallBorderRadius = 8.0;
ThemeData themeData() {
  return ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    primarySwatch: Colors.amber,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      // color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black54,
        fontSize: 21,
        fontWeight: FontWeight.w500,
      ),
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
    ),
    fontFamily: 'Quicksand',
  );
}
