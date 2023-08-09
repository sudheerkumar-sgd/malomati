import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeBlue extends ApplicationTheme {
  static ThemeBlue? _instance;
  static ThemeBlue get instance {
    _instance ??= ThemeBlue._init();
    return _instance!;
  }

  String? _fontFamily;
  @override
  fontFamily(String fontFamily) {
    _fontFamily = fontFamily;
  }

  ThemeBlue._init();

  @override
  @override
  ThemeData? get theme => ThemeData(
        primarySwatch: const MaterialColor(4288120051, {
          50: Color(0xffebe8fd),
          100: Color(0xffd8d1fa),
          200: Color(0xffb0a2f6),
          300: Color(0xff8974f1),
          400: Color(0xff6245ed),
          500: Color(0xff3b17e8),
          600: Color(0xff2f12ba),
          700: Color(0xff230e8b),
          800: Color(0xff17095d),
          900: Color(0xff0c052e)
        }),
        brightness: Brightness.light,
        primaryColor: const Color(0xff9784f3),
        primaryColorLight: const Color(0xffd8d1fa),
        primaryColorDark: const Color(0xff230e8b),
        canvasColor: const Color(0xfffafafa),
        scaffoldBackgroundColor: const Color(0xfffafafa),
        cardColor: const Color(0xffffffff),
        dividerColor: const Color(0x1f000000),
        highlightColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        unselectedWidgetColor: const Color(0x8a000000),
        disabledColor: const Color(0x61000000),
        secondaryHeaderColor: const Color(0xffebe8fd),
        dialogBackgroundColor: const Color(0xffffffff),
        indicatorColor: const Color(0xff3b17e8),
        hintColor: const Color(0x8a000000),
        fontFamily: _fontFamily ?? 'Inter',
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          radius: const Radius.circular(10.0),
          thumbColor: MaterialStateProperty.all(const Color(0xff3b17e8)),
        ),
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          minWidth: 88,
          height: 36,
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff000000),
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          displayMedium: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          displaySmall: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          headlineMedium: TextStyle(
            color: Color(0x8a000000),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          headlineSmall: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          titleLarge: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          titleMedium: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          bodyLarge: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          bodyMedium: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          bodySmall: TextStyle(
            color: Color(0x8a233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          labelLarge: TextStyle(
            color: Color(0xdd233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          titleSmall: TextStyle(
            color: Color(0xff233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          labelSmall: TextStyle(
            color: Color(0xff233057),
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
      );
}
