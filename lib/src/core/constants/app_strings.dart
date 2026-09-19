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

  // Reading surface preferences
  static final spQuranNightMode = "${_config.packageName}.quran_night_mode";
  static final spQuranArabicScale =
      "${_config.packageName}.quran_arabic_scale";
  static final spQuranTranslationScale =
      "${_config.packageName}.quran_translation_scale";
  static final spQuranShowTranslation =
      "${_config.packageName}.quran_show_translation";

  // Daily reading plan
  static final spReadingPlanType = "${_config.packageName}.reading_plan_type";
  static final spReadingPlanTarget =
      "${_config.packageName}.reading_plan_target";

  // Hadith
  static final spHadithCachePrefix = "${_config.packageName}.hadith_cache";
  static final spHadithBookmarks = "${_config.packageName}.hadith_bookmarks";

  /// Which version of the bundled hadith corpus is inflated on this device.
  static final spHadithDbVersion = "${_config.packageName}.hadith_db_version";
  static final spHadithLastRead = "${_config.packageName}.hadith_last_read";

  // Prayer times
  static final spPrayerMethod = "${_config.packageName}.prayer_method";
  static final spPrayerHanafi = "${_config.packageName}.prayer_hanafi";
  static final spPrayerOffsetPrefix = "${_config.packageName}.prayer_offset";

  // Notifications
  static final spNotifGlobal = "${_config.packageName}.notif_global";
  static final spNotifDua = "${_config.packageName}.notif_dua";
  static final spNotifPrayerPrefix = "${_config.packageName}.notif_prayer";

  // Adhan & reminders (Dusk)
  static final spAdhanModePrefix = "${_config.packageName}.adhan_mode";
  static final spAdhanSoundPrefix = "${_config.packageName}.adhan_sound";
  static final spAdhanOffsetPrefix = "${_config.packageName}.adhan_offset";
  static final spReminderPrefix = "${_config.packageName}.reminder";

  // Tasbih
  static final spTasbihActiveDhikr =
      "${_config.packageName}.tasbih_active_dhikr";
  static final spTasbihTargetPrefix = "${_config.packageName}.tasbih_target";
  static final spTasbihHaptics = "${_config.packageName}.tasbih_haptics";

  // Jamaat times recorded against a specific masjid, as a JSON map
  static final spMasjidJamaatPrefix =
      "${_config.packageName}.masjid_jamaat";

  // Jamaat times, one per prayer, stored as HH:mm
  static final spJamaatTimePrefix = "${_config.packageName}.jamaat_time";

  // Onboarding
  static final spOnboardingComplete =
      "${_config.packageName}.onboarding_complete";
  static final spManualCity = "${_config.packageName}.manual_city";

  // Location label shown in the home hero and the আরও settings row
  static final spLocationLabel = "${_config.packageName}.location_label";

  // Zakat working figures, kept so a half-finished calculation survives
  // closing the app — people gather these numbers over several sittings.
  static final spZakatDraft = "${_config.packageName}.zakat_draft";

  // Hijri correction, in days, from the calendar screen
  static final spHijriOffset = "${_config.packageName}.hijri_offset";

  // Notification channel ids
  static final notificationChannelId =
      "${_config.packageName}.al_muttaqee_channel";
  static const notificationChannelName = "al_muttaqee Channel";

  // Endpoints
  static const urlGetUser = "v1/token-user";
  static const urlHadithBase = "hadith";
}
