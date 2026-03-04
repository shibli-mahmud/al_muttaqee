import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/bindings/initial_bindings.dart';

import 'core/config/build_config.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  static ThemeData _themeForLocale(Locale? locale) {
    final isBangla = locale != null && locale.languageCode == 'bn';
    final base = ThemeData();
    return base.copyWith(
      textTheme: isBangla
          ? GoogleFonts.notoSansBengaliTextTheme(base.textTheme)
          : base.textTheme.apply(fontFamily: 'Figtree'),
      primaryTextTheme: isBangla
          ? GoogleFonts.notoSansBengaliTextTheme(base.primaryTextTheme)
          : base.primaryTextTheme.apply(fontFamily: 'Figtree'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = BuildConfig.instance.envConfig;
    final locale = Get.locale;

    return GetMaterialApp(
      key: ValueKey(locale?.languageCode ?? ''),
      title: config.appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: L10n.locals,
      locale: locale,
      theme: _themeForLocale(locale),
      debugShowCheckedModeBanner: false,
    );
  }
}
