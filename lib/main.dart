import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:al_muttaqee/src/core/config/build_config.dart';
import 'package:al_muttaqee/src/core/local/db/app_database.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/utils/utils/location_service.dart';
import 'package:al_muttaqee/src/core/utils/utils/notification_service.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'src/application.dart';
import 'src/core/config/env_config.dart';
import 'package:al_muttaqee/l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    try {
      await dotenv.load(fileName: '.env.example');
    } catch (e) {
      debugPrint('dotenv: no env file loaded. $e');
    }
  }

  final packageInfo = await PackageInfo.fromPlatform();
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://alquranbd.com/api/';

  final envConfig = EnvConfig(
    appName: packageInfo.appName,
    appVersion: packageInfo.version,
    packageName: packageInfo.packageName,
    baseUrl: baseUrl,
  );

  BuildConfig.instantiate(config: envConfig);

  await L10n.getLocale();
  await Quran.initialize();

  Get.put(PreferenceManagerImpl(), permanent: true);
  Get.put(LocationService(), permanent: true);

  // The tracker reads its first day the moment হোম builds, so the database is
  // opened before the first frame rather than lazily behind a spinner.
  Get.put(await AppDatabase().init(), permanent: true);

  final notifications = await NotificationService().init();
  Get.put(notifications, permanent: true);

  // Refill the rolling alarm window on every cold start. The plugin re-arms
  // what it already holds after a reboot, but only a launch can extend the
  // window past the seven days scheduled last time.
  unawaited(notifications.rescheduleAll());

  runApp(const Application());
}
