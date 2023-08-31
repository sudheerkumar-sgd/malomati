import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malomati/config/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:malomati/core/common/common.dart';
import 'core/enum.dart';
import 'res/theme/theme_blue.dart';
import 'res/theme/theme_red.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var value = context.userDB;
    final Locale locale =
        Locale(value.get(appLocalKey, defaultValue: LocalEnum.en.name));
    var theme = (value.get(appThemeKey, defaultValue: ThemeEnum.red.name) ==
            ThemeEnum.blue.name)
        ? ThemeBlue.instance
        : ThemeRed.instance;
    theme.fontFamily(
        locale.languageCode == LocalEnum.ar.name ? fontFamilyAR : fontFamilyEN);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: context.resources.color.bgGradientStart,
        statusBarIconBrightness: Brightness.light));
    oracleLoginId = value.get(oracleLoginIdKey, defaultValue: '');
    isLocalEn = (locale.languageCode == LocalEnum.en.name);
    return MaterialApp(
      locale: locale,
      debugShowCheckedModeBanner: false,
      title: 'Malomati',
      theme: theme.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (BuildContext context) => context.string.appTitle,
      initialRoute: value.get(isSplashDoneKey, defaultValue: false)
          ? oracleLoginId.isEmpty
              ? AppRoutes.loginRoute
              : AppRoutes.mainRoute
          : AppRoutes.initialRoute,
      routes: AppRoutes.getRoutes(),
    );
  }
}
