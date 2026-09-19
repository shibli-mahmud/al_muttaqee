part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const qibla = _Paths.qibla;
  static const quran = _Paths.quran;
  static const readingPlan = _Paths.readingPlan;
  static const tasbih = _Paths.tasbih;
  static const tasbihHistory = _Paths.tasbihHistory;
  static const prayerTimes = _Paths.prayerTimes;
  static const prayerSettings = _Paths.prayerSettings;
  static const adhanSettings = _Paths.adhanSettings;
  static const adhanSettingsPrayer = _Paths.adhanSettingsPrayer;
  static const hadith = _Paths.hadith;
  static const hadithCollection = _Paths.hadithCollection;
  static const hadithChapter = _Paths.hadithChapter;
  static const hadithSearch = _Paths.hadithSearch;
  static const hadithBookmarks = _Paths.hadithBookmarks;
  static const notifications = _Paths.notifications;
  static const masjidFinder = _Paths.masjidFinder;
  static const more = _Paths.more;
  static const dua = _Paths.dua;
  static const ramadan = _Paths.ramadan;
  static const names99 = _Paths.names99;
  static const widgets = _Paths.widgets;
  static const pro = _Paths.pro;
  static const calendar = _Paths.calendar;
  static const zakat = _Paths.zakat;
  static const zakatHistory = _Paths.zakatHistory;

  /// `/adhan-settings/fajr` for a given prayer.
  static String adhanSettingsFor(String prayer) => '$adhanSettings/$prayer';

  /// `/hadith/bukhari` for a given collection.
  static String hadithCollectionFor(String slug) => '$hadith/$slug';
}

abstract class _Paths {
  static const splash = "/splash";
  static const onboarding = "/onboarding";
  static const dashboard = "/dashboard";
  static const home = "/home";
  static const qibla = "/qibla";
  static const quran = "/quran";
  static const readingPlan = "/reading-plan";
  static const tasbih = "/tasbih";
  static const tasbihHistory = "/tasbih/history";
  static const prayerTimes = "/prayer-times";
  static const prayerSettings = "/prayer-settings";
  static const adhanSettings = "/adhan-settings";
  static const adhanSettingsPrayer = "/adhan-settings/:prayer";
  static const hadith = "/hadith";
  static const hadithCollection = "/hadith/:collection";
  static const hadithChapter = "/hadith-chapter";
  static const hadithSearch = "/hadith-search";
  static const hadithBookmarks = "/hadith-bookmarks";
  static const notifications = "/notifications";
  static const masjidFinder = "/masjid-finder";
  static const more = "/more";
  static const dua = "/dua";
  static const ramadan = "/ramadan";
  static const names99 = "/names-99";
  static const widgets = "/widgets";
  static const pro = "/pro";
  static const calendar = "/calendar";
  static const zakat = "/zakat";
  static const zakatHistory = "/zakat/history";
}
