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
  static const hadith = _Paths.hadith;
  static const notifications = _Paths.notifications;
  static const masjidFinder = _Paths.masjidFinder;
  static const pro = _Paths.pro;
  static const calendar = _Paths.calendar;
  static const zakat = _Paths.zakat;
}

abstract class _Paths {
  static const splash = "/splash";
  static const dashboard = "/dashboard";
  static const home = "/home";
  static const qibla = "/qibla";
  static const quran = "/quran";
  static const tasbih = "/tasbih";
  static const prayerTimes = "/prayer-times";
  static const hadith = "/hadith";
  static const notifications = "/notifications";
  static const masjidFinder = "/masjid-finder";
  static const pro = "/pro";
  static const calendar = "/calendar";
  static const zakat = "/zakat";
}
