

import 'package:flutter/material.dart';

ThemeData getNormalTheme() {
   return ThemeData(
     primarySwatch: Colors.blueGrey,
     visualDensity: VisualDensity.adaptivePlatformDensity,
   ).copyWith(
     textTheme: TextTheme(
       headline1: TextStyle(
           fontSize: 25,
           fontWeight: FontWeight.w600,
           color: Colors.black
       ),
       headline2: TextStyle(
           fontSize: 21,
           fontWeight: FontWeight.w700,
           color: Colors.black
       ),
       bodyText1: TextStyle(
           height: 1.4,
           fontSize: 15,
           fontWeight: FontWeight.w400,
           color: Colors.black
       ),
       button: TextStyle(
         fontSize: 15,
       ),
     ),
   );
 }

ThemeData getBlackTheme() {
  final theme = ThemeData.dark();

  return theme.copyWith(
    primaryColor: theme.scaffoldBackgroundColor,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        height: 1.4,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      button: TextStyle(
        fontSize: 18,
      ),
    ),
  );
}