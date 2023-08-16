import 'package:flutter/material.dart';

import 'base_clors.dart';

class ThemeRedColors implements BaseColors {
  final Map<int, Color> _primary = const {
    50: Color.fromRGBO(22, 134, 206, 0.1),
    100: Color.fromRGBO(22, 134, 206, 0.2),
    200: Color.fromRGBO(22, 134, 206, 0.3),
    300: Color.fromRGBO(22, 134, 206, 0.4),
    400: Color.fromRGBO(22, 134, 206, 0.5),
    500: Color.fromRGBO(22, 134, 206, 0.6),
    600: Color.fromRGBO(22, 134, 206, 0.7),
    700: Color.fromRGBO(22, 134, 206, 0.8),
    800: Color.fromRGBO(22, 134, 206, 0.9),
    900: Color.fromRGBO(22, 134, 206, 1.0),
  };

  @override
  MaterialColor get colorAccent => Colors.amber;

  @override
  MaterialColor get colorPrimary => MaterialColor(0xff1686ce, _primary);

  @override
  Color get colorPrimaryText => const Color(0xff49ABFF);

  @override
  Color get colorSecondaryText => const Color(0xff3593FF);

  @override
  Color get colorWhite => const Color(0xffffffff);

  @override
  Color get colorBlack => const Color(0xff000000);

  @override
  Color get castChipColor => Colors.deepOrangeAccent;

  @override
  Color get catChipColor => Colors.indigoAccent;

  @override
  Color get bgColor => Colors.white;

  @override
  Color get bgGradientEnd => const Color(0xFFC1213F);

  @override
  Color get bgGradientStart => const Color(0xFFEC294E);

  @override
  Color get textColor => const Color(0xFF233057);

  @override
  Color get textColorLight => const Color(0xFF979797);

  @override
  Color get viewBgColor => const Color(0xFFDD143A);

  @override
  Color get viewBgColorLight => const Color(0xFFEC294E);

  @override
  Color get colorEDECEC => const Color(0xffEDECEC);

  @override
  Color get bottomSheetIconSelected => bgGradientEnd;

  @override
  Color get bottomSheetIconUnSelected => const Color(0xffD8D8D8);

  @override
  Color get appScaffoldBg => const Color(0xffF5F5F5);

  @override
  Color get colorF5C3C3 => const Color(0xffF5C3C3);

  @override
  Color get textColor212B4B => const Color(0xff212B4B);

  @override
  Color get colorD6D6D6 => const Color(0xffD6D6D6);

  @override
  Color get colorD32030 => const Color(0xffD32030);

  @override
  Color get colorGreen26B757 => const Color(0xff26B757);

  @override
  Color get colorBlue356DCE => const Color(0xff356DCE);
}
