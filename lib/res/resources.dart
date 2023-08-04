import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/colors/base_clors.dart';
import 'package:malomati/res/colors/theme_blue_colors.dart';
import 'package:malomati/res/theme/app_theme.dart';
import 'package:malomati/res/theme/theme_blue.dart';
import 'package:malomati/res/theme/theme_red.dart';
import '../core/enum.dart';
import 'colors/theme_red_colors.dart';
import 'dimentions/app_dimension.dart';

class Resources {
  final BuildContext context;
  Resources(this.context);

  BaseColors get color {
    final theme = Hive.box(appSettingsDb).get(appThemeKey);
    return (theme == ThemeEnum.blue.name)
        ? ThemeBlueColors()
        : ThemeRedColors();
  }

  ApplicationTheme get theme {
    final theme = Hive.box(appSettingsDb).get(appThemeKey);
    return (theme == ThemeEnum.blue.name)
        ? ThemeBlue.instance
        : ThemeRed.instance;
  }

  AppDimension get dimen {
    return AppDimension();
  }

  void setTheme() {
    final theme =
        context.settingDB.get(appThemeKey, defaultValue: ThemeEnum.red.name);
    (theme == ThemeEnum.blue.name)
        ? context.settingDB.put(appThemeKey, ThemeEnum.red.name)
        : context.settingDB.put(appThemeKey, ThemeEnum.blue.name);
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

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
