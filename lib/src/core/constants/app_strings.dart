import 'package:al_muttaqee/src/core/config/build_config.dart';

abstract class AppStrings {
  static final _config = BuildConfig.instance.envConfig;

  // Shared Preference key
  static final spAlreadyInstalled =
      "${_config.packageName}.app_already_installed";
  static final spAccessToken = "${_config.packageName}.user_access_token";
  static final spLocale = "${_config.packageName}.app_locale";

  static final spLanguage = "${_config.packageName}.language";

  // Quran
  static final spQuranLastSurahNumber =
      "${_config.packageName}.quran_last_surah_number";
  static final spQuranLastAyahNumber =
      "${_config.packageName}.quran_last_ayah_number";
  static final spQuranReciter = "${_config.packageName}.quran_reciter";
  static final spQuranDownloadedSurahs =
      "${_config.packageName}.quran_downloaded_surahs";

  // Hadith
  static final spHadithCachePrefix = "${_config.packageName}.hadith_cache";
  static final spHadithBookmarks = "${_config.packageName}.hadith_bookmarks";

  // Prayer times
  static final spPrayerMethod = "${_config.packageName}.prayer_method";
  static final spPrayerHanafi = "${_config.packageName}.prayer_hanafi";
  static final spPrayerOffsetPrefix = "${_config.packageName}.prayer_offset";

  // Notifications
  static final spNotifGlobal = "${_config.packageName}.notif_global";
  static final spNotifDua = "${_config.packageName}.notif_dua";
  static final spNotifPrayerPrefix = "${_config.packageName}.notif_prayer";

  // Notification channel ids
  static final notificationChannelId =
      "${_config.packageName}.al_muttaqee_channel";
  static const notificationChannelName = "al_muttaqee Channel";

  // Endpoints
  static const urlGetUser = "v1/token-user";
  static const urlHadithBase = "hadith";
}
