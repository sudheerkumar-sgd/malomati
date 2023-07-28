import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/res/colors/base_clors.dart';
import 'package:malomati/res/colors/theme_blue_colors.dart';
import 'package:malomati/res/theme/app_theme.dart';
import 'package:malomati/res/theme/theme_blue.dart';
import 'package:malomati/res/theme/theme_red.dart';

import '../core/constants/constants.dart';
import '../core/enum.dart';
import 'colors/theme_red_colors.dart';
import 'dimentions/app_dimension.dart';

class Resources {
  Resources();

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
    final appSettings = Hive.box(appSettingsDb);
    final theme =
        appSettings.get(appThemeKey, defaultValue: ThemeEnum.red.name);
    (theme == ThemeEnum.blue.name)
        ? appSettings.put(appThemeKey, ThemeEnum.red.name)
        : appSettings.put(appThemeKey, ThemeEnum.blue.name);
  }

  bool get isLocalEn => getLocal();

  void setLocal({String? language}) {
    final appSettings = Hive.box(appSettingsDb);
    if (language != null) {
      appSettings.put(appLocalKey, language);
    } else {
      final local =
          appSettings.get(appLocalKey, defaultValue: LocalEnum.en.name);
      (local == LocalEnum.ar.name)
          ? appSettings.put(appLocalKey, LocalEnum.en.name)
          : appSettings.put(appLocalKey, LocalEnum.ar.name);
    }
  }

  bool getLocal() {
    final appSettings = Hive.box(appSettingsDb);
    final local = appSettings.get(appLocalKey, defaultValue: LocalEnum.en.name);
    return (local == LocalEnum.en.name);
  }

  static Resources of() {
    return Resources();
  }
}
