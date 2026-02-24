import 'package:flutter/material.dart';
import 'package:islamic_app/l10n/app_localizations.dart';
import 'package:islamic_app/l10n/l10n.dart';
import 'package:islamic_app/src/bindings/initial_bindings.dart';

import 'core/config/build_config.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final config = BuildConfig.instance.envConfig;

    return GetMaterialApp(
      title: config.appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: L10n.locals,
      locale: Get.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
