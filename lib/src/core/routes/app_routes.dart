part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const qibla = _Paths.qibla;
  static const quran = _Paths.quran;
  static const tasbih = _Paths.tasbih;
  static const prayerTimes = _Paths.prayerTimes;
}

abstract class _Paths {
  static const splash = "/splash";
  static const dashboard = "/dashboard";
  static const home = "/home";
  static const qibla = "/qibla";
  static const quran = "/quran";
  static const tasbih = "/tasbih";
  static const prayerTimes = "/prayer-times";
}
