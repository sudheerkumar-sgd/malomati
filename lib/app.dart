import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    return ValueListenableBuilder(
      valueListenable: Hive.box(appSettingsDb).listenable(),
      builder: (context, value, widget) {
        final Locale locale =
            Locale(value.get(appLocalKey, defaultValue: LocalEnum.en.name));
        var theme = (value.get(appThemeKey, defaultValue: ThemeEnum.red.name) ==
                ThemeEnum.blue.name)
            ? ThemeBlue.instance
            : ThemeRed.instance;
        theme.fontFamily(locale.languageCode == LocalEnum.ar.name
            ? fontFamilyAR
            : fontFamilyEN);
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: theme.theme?.primaryColor));
        return MaterialApp(
          locale: locale,
          debugShowCheckedModeBanner: false,
          title: 'Malomati',
          theme: theme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (BuildContext context) => context.string.appTitle,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
