import 'package:flutter/material.dart';

ThemeData getNormalTheme() {
  final theme = ThemeData.light().copyWith(
    //修改状态栏颜色
//    brightness: Brightness.dark,
    primaryIconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
    primaryColor: Color(0xFFEAEAEA),
    primaryColorLight: Color(0xFFE0E0E0),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: Colors.black),
        contentTextStyle: TextStyle(
          color: Colors.black,
        )),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 22,
        color: Color(0xFF000000),
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
          fontSize: 21, fontWeight: FontWeight.w700, color: Colors.black),
      bodyText1: TextStyle(
          height: 1.4,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black),
      button: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    ),
  );
  return theme;
}

ThemeData getBlackTheme() {
  final theme = ThemeData.dark();

  return theme.copyWith(
    primaryColor: theme.scaffoldBackgroundColor,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headline2: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        height: 1.4,
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
      button: TextStyle(
        fontSize: 18,
      ),
    ),
  );
}
