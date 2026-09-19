import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/bindings/initial_bindings.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';

import 'core/config/build_config.dart';
import 'core/routes/app_pages.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  /// The Dusk theme.
  ///
  /// Anek Bangla is the default family in both locales rather than only under
  /// `bn`: the app is Bangla-first, its interface copy is Bangla even for a
  /// user reading English content, and Anek carries Latin well enough that
  /// swapping families per locale would only make the two builds diverge.
  static ThemeData _theme() {
    final base = ThemeData(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.duskDeep,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: DuskText.fontBangla,
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        fontFamily: DuskText.fontBangla,
      ),
      splashColor: AppColors.sage.withValues(alpha: 0.4),
      highlightColor: AppColors.sage.withValues(alpha: 0.25),
      dividerColor: AppColors.hairline,
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
      theme: _theme(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Respect the user's text scale, but cap it: the audience includes
        // people running large system text, and past 1.3x the five-cell strips
        // and tracker rows stop fitting no matter how the cards grow.
        final scaler = MediaQuery.textScalerOf(context)
            .clamp(maxScaleFactor: AppValues.maxTextScale);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scaler),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
