import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

extension TextStyleHelper on BuildContext {
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  //Custom styles
  TextStyle get textFontWeight400 => TextStyle(
        color: resources.color.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight600 => TextStyle(
        color: resources.color.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight700 => TextStyle(
        color: resources.color.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );
  TextStyle get textFontWeight900 => TextStyle(
        color: resources.color.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
      );
}

extension TextStyleColorMapping on TextStyle {
  TextStyle onPrimary(BuildContext context) {
    return copyWith(color: context.onPrimary);
  }

  TextStyle onSecondary(BuildContext context) {
    return copyWith(color: context.onSecondary);
  }

  TextStyle onTertiary(BuildContext context) {
    return copyWith(color: context.onTertiary);
  }

  TextStyle onPrimaryContainer(BuildContext context) {
    return copyWith(color: context.onPrimaryContainer);
  }

  TextStyle onSecondaryContainer(BuildContext context) {
    return copyWith(color: context.onSecondaryContainer);
  }

  TextStyle onTertiaryContainer(BuildContext context) {
    return copyWith(color: context.onTertiaryContainer);
  }

  TextStyle onSurface(BuildContext context) {
    return copyWith(color: context.onSurface);
  }

  //custom colors
  TextStyle onColor(Color color) {
    return copyWith(color: color);
  }
}

extension TextStyleFontSizeMapping on TextStyle {
  //custom font Sizes
  TextStyle onFontSize(double size) {
    return copyWith(fontSize: size);
  }
}
