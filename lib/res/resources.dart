import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/colors/base_clors.dart';
import 'package:malomati/res/colors/theme_peach_colors.dart';
import 'package:malomati/res/dimentions/font_dimension.dart';
import 'package:malomati/res/dimentions/font_dimension_big.dart';
import 'package:malomati/res/dimentions/font_dimension_small.dart';
import 'package:malomati/res/theme/app_theme.dart';
import 'package:malomati/res/theme/theme_blue.dart';
import 'package:malomati/res/theme/theme_peach.dart';
import 'package:malomati/res/theme/theme_red.dart';
import '../core/enum.dart';
import 'colors/theme_blue_colors.dart';
import 'colors/theme_red_colors.dart';
import 'dimentions/app_dimension.dart';
import 'dimentions/font_dimension_default.dart';

class Resources {
  final BuildContext context;
  Resources(this.context);

  BaseColors get color {
    final theme = Hive.box(appSettingsDb).get(appThemeKey);
    return (theme == ThemeEnum.blue.name)
        ? ThemeBlueColors()
        : (theme == ThemeEnum.peach.name)
            ? ThemePeachColors()
            : ThemeRedColors();
  }

  ApplicationTheme get theme {
    final theme = Hive.box(appSettingsDb).get(appThemeKey);
    return (theme == ThemeEnum.peach.name)
        ? ThemePeach.instance
        : (theme == ThemeEnum.blue.name)
            ? ThemeBlue.instance
            : ThemeRed.instance;
  }

  AppDimension get dimen {
    return AppDimension();
  }

  void setTheme(ThemeEnum theme) {
    (theme == ThemeEnum.peach)
        ? context.settingDB.put(appThemeKey, ThemeEnum.peach.name)
        : (theme == ThemeEnum.blue)
            ? context.settingDB.put(appThemeKey, ThemeEnum.blue.name)
            : context.settingDB.put(appThemeKey, ThemeEnum.red.name);
    Phoenix.rebirth(context);
  }

  bool get isLocalEn => getLocal();

  void setLocal({String? language}) {
    if (language != null) {
      context.settingDB.put(appLocalKey, language);
    } else {
      final local =
          context.settingDB.get(appLocalKey, defaultValue: LocalEnum.en.name);
      (local == LocalEnum.ar.name)
          ? context.settingDB.put(appLocalKey, LocalEnum.en.name)
          : context.settingDB.put(appLocalKey, LocalEnum.ar.name);
    }
    Phoenix.rebirth(context);
  }

  bool getLocal() {
    final local =
        context.settingDB.get(appLocalKey, defaultValue: LocalEnum.en.name);
    return (local == LocalEnum.en.name);
  }

  ThemeEnum getTheme() {
    final theme =
        context.settingDB.get(appThemeKey, defaultValue: ThemeEnum.red.name);
    return ThemeEnum.values.byName(theme);
  }

  Color get iconBgColor => color.viewBgColorLight;

  FontSizeEnum? currentFontSize;

  FontSizeEnum getUserSelcetedFontSize() {
    if (currentFontSize == null) {
      final fontSize = context.settingDB.get(appFontSizeKey, defaultValue: 2);
      currentFontSize = FontSizeEnum.fromSize(fontSize);
    }
    return currentFontSize ?? FontSizeEnum.defaultSize;
  }

  void setFontSize(FontSizeEnum size) {
    context.settingDB.put(appFontSizeKey, size.size);
    Phoenix.rebirth(context);
  }

  FontDimensions get fontSize {
    switch (getUserSelcetedFontSize()) {
      case FontSizeEnum.bigSize:
        return FontDimensionsBig();
      case FontSizeEnum.smallSize:
        return FontDimensionsSmall();
      default:
        return FontDimensionsDefault();
    }
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
