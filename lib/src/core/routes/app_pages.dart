import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/src/core/shared/widgets/dusk/coming_soon_view.dart';
import 'package:al_muttaqee/src/module/calendar/bindings/calendar_binding.dart';
import 'package:al_muttaqee/src/module/calendar/views/calendar_view.dart';
import 'package:al_muttaqee/src/module/dashboard/bindings/dashboard_binding.dart';
import 'package:al_muttaqee/src/module/dashboard/views/dashboard_view.dart';
import 'package:al_muttaqee/src/module/dua/bindings/dua_binding.dart';
import 'package:al_muttaqee/src/module/dua/views/dua_view.dart';
import 'package:al_muttaqee/src/module/hadith/bindings/hadith_binding.dart';
import 'package:al_muttaqee/src/module/hadith/views/hadith_bookmarks_view.dart';
import 'package:al_muttaqee/src/module/hadith/views/hadith_chapter_view.dart';
import 'package:al_muttaqee/src/module/hadith/views/hadith_collection_view.dart';
import 'package:al_muttaqee/src/module/hadith/views/hadith_search_view.dart';
import 'package:al_muttaqee/src/module/hadith/views/hadith_view.dart';
import 'package:al_muttaqee/src/module/home/bindings/home_binding.dart';
import 'package:al_muttaqee/src/module/home/views/home_view.dart';
import 'package:al_muttaqee/src/module/masjid_finder/bindings/masjid_finder_binding.dart';
import 'package:al_muttaqee/src/module/masjid_finder/views/masjid_finder_view.dart';
import 'package:al_muttaqee/src/module/more/bindings/more_binding.dart';
import 'package:al_muttaqee/src/module/more/views/more_view.dart';
import 'package:al_muttaqee/src/module/notifications/bindings/adhan_settings_binding.dart';
import 'package:al_muttaqee/src/module/notifications/views/adhan_prayer_detail_view.dart';
import 'package:al_muttaqee/src/module/notifications/views/adhan_settings_view.dart';
import 'package:al_muttaqee/src/module/onboarding/bindings/onboarding_binding.dart';
import 'package:al_muttaqee/src/module/onboarding/views/onboarding_view.dart';
import 'package:al_muttaqee/src/module/prayer_times/bindings/prayer_times_binding.dart';
import 'package:al_muttaqee/src/module/prayer_times/views/prayer_settings_view.dart';
import 'package:al_muttaqee/src/module/prayer_times/views/prayer_times_view.dart';
import 'package:al_muttaqee/src/module/pro/bindings/pro_binding.dart';
import 'package:al_muttaqee/src/module/pro/views/pro_view.dart';
import 'package:al_muttaqee/src/module/qibla/bindings/qibla_binding.dart';
import 'package:al_muttaqee/src/module/qibla/views/qibla_view.dart';
import 'package:al_muttaqee/src/module/quran/bindings/quran_binding.dart';
import 'package:al_muttaqee/src/module/ramadan/bindings/ramadan_binding.dart';
import 'package:al_muttaqee/src/module/ramadan/views/ramadan_view.dart';
import 'package:al_muttaqee/src/module/quran/views/quran_view.dart';
import 'package:al_muttaqee/src/module/quran/views/reading_plan_view.dart';
import 'package:al_muttaqee/src/module/splash/bindings/splash_binding.dart';
import 'package:al_muttaqee/src/module/splash/views/splash_view.dart';
import 'package:al_muttaqee/src/module/tasbih/bindings/tasbih_binding.dart';
import 'package:al_muttaqee/src/module/tasbih/views/tasbih_history_view.dart';
import 'package:al_muttaqee/src/module/tasbih/views/tasbih_view.dart';
import 'package:al_muttaqee/src/module/zakat/bindings/zakat_binding.dart';
import 'package:al_muttaqee/src/module/zakat/views/zakat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.splash,
      binding: SplashBinding(),
      page: () => SplashView(),
    ),
    GetPage(
      name: Routes.onboarding,
      binding: OnboardingBinding(),
      page: () => OnboardingView(),
    ),
    GetPage(
      name: Routes.dashboard,
      binding: DashboardBinding(),
      page: () => DashboardView(),
    ),
    GetPage(name: Routes.home, binding: HomeBinding(), page: () => HomeView()),
    GetPage(
      name: Routes.quran,
      binding: QuranBinding(),
      page: () => QuranView(),
    ),
    GetPage(
      name: Routes.readingPlan,
      binding: QuranBinding(),
      page: () => ReadingPlanView(),
    ),
    GetPage(
      name: Routes.qibla,
      binding: QiblaBinding(),
      page: () => QiblaView(),
    ),
    GetPage(
      name: Routes.tasbih,
      binding: TasbihBinding(),
      page: () => TasbihView(),
    ),
    GetPage(
      name: Routes.tasbihHistory,
      binding: TasbihBinding(),
      page: () => TasbihHistoryView(),
    ),
    GetPage(
      name: Routes.prayerTimes,
      binding: PrayerTimesBinding(),
      page: () => PrayerTimesView(),
    ),
    GetPage(
      name: Routes.prayerSettings,
      binding: PrayerTimesBinding(),
      page: () => PrayerSettingsView(),
    ),
    GetPage(
      name: Routes.adhanSettings,
      binding: AdhanSettingsBinding(),
      page: () => AdhanSettingsView(),
    ),
    // Must be registered after its parent so `/adhan-settings` still matches
    // the list rather than being swallowed by the parameterised path.
    GetPage(
      name: Routes.adhanSettingsPrayer,
      binding: AdhanSettingsBinding(),
      page: () => AdhanPrayerDetailView(),
    ),
    GetPage(
      name: Routes.more,
      binding: MoreBinding(),
      page: () => MoreView(),
    ),
    GetPage(
      name: Routes.hadith,
      binding: HadithBinding(),
      page: () => HadithView(),
    ),
    // After its parent, so `/hadith` still matches the index rather than
    // being swallowed by the parameterised path.
    GetPage(
      name: Routes.hadithCollection,
      binding: HadithBinding(),
      page: () => HadithCollectionView(),
    ),
    GetPage(
      name: Routes.hadithChapter,
      binding: HadithBinding(),
      page: () => HadithChapterView(),
    ),
    GetPage(
      name: Routes.hadithSearch,
      binding: HadithBinding(),
      page: () => HadithSearchView(),
    ),
    GetPage(
      name: Routes.hadithBookmarks,
      binding: HadithBinding(),
      page: () => HadithBookmarksView(),
    ),
    GetPage(
      name: Routes.notifications,
      binding: AdhanSettingsBinding(),
      page: () => AdhanSettingsView(),
    ),
    GetPage(
      name: Routes.masjidFinder,
      binding: MasjidFinderBinding(),
      page: () => MasjidFinderView(),
    ),
    GetPage(name: Routes.pro, binding: ProBinding(), page: () => ProView()),
    GetPage(
      name: Routes.calendar,
      binding: CalendarBinding(),
      page: () => CalendarView(),
    ),
    GetPage(
      name: Routes.zakat,
      binding: ZakatBinding(),
      page: () => ZakatView(),
    ),
    GetPage(name: Routes.dua, binding: DuaBinding(), page: () => DuaView()),
    GetPage(
      name: Routes.ramadan,
      binding: RamadanBinding(),
      page: () => RamadanView(),
    ),

    // ── Designed, not yet built ─────────────────────────────────────────────
    // The আরও grid shows the whole feature set, so these routes exist and land
    // on a "coming soon" screen rather than leaving dead tiles. Each is
    // replaced by its real screen in phase 2 or 3.
    GetPage(
      name: Routes.zakatHistory,
      page: () => ComingSoonPage(
        titleBuilder: (l10n) => l10n.zakat,
        icon: PhosphorIconsRegular.clockCounterClockwise,
      ),
    ),
    GetPage(
      name: Routes.names99,
      page: () => ComingSoonPage(
        titleBuilder: (l10n) => l10n.tileNames99,
        icon: PhosphorIconsRegular.sparkle,
      ),
    ),
    GetPage(
      name: Routes.widgets,
      page: () => ComingSoonPage(
        titleBuilder: (l10n) => l10n.tileWidget,
        icon: PhosphorIconsRegular.squaresFour,
      ),
    ),
  ];
}
