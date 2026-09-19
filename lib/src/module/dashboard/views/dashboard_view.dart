import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:al_muttaqee/src/module/home/views/home_view.dart';
import 'package:al_muttaqee/src/module/more/views/more_view.dart';
import 'package:al_muttaqee/src/module/prayer_times/views/prayer_times_view.dart';
import 'package:al_muttaqee/src/module/quran/views/quran_view.dart';
import 'package:al_muttaqee/src/module/tasbih/views/tasbih_view.dart';

/// The five-tab shell.
///
/// The language drawer is gone — language now lives in আরও → ভাষা, where a
/// setting belongs. A drawer for a single two-item choice was a whole gesture
/// most of this audience never discovered.
class DashboardView extends BaseView<DashboardController> {
  DashboardView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  /// Each tab draws its own hero right up under the status bar, so the shell
  /// must not inset for it.
  @override
  Widget pageContent(BuildContext context) => body(context);

  @override
  Widget body(BuildContext context) {
    final pages = <Widget>[
      HomeView(),
      QuranView(),
      PrayerTimesView(),
      TasbihView(),
      MoreView(),
    ];

    // IndexedStack, not a swap: it keeps each tab's scroll position, so
    // stepping out of the Quran to check a prayer time and back does not throw
    // away where the user was reading.
    return Obx(
      () => IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      ),
    );
  }

  @override
  Widget? bottomNavigationBar() {
    final l10n = appLocalization;
    final items = [
      DuskNavItem(
        label: l10n.navHome,
        icon: PhosphorIconsRegular.house,
        activeIcon: PhosphorIconsFill.house,
      ),
      DuskNavItem(
        label: l10n.navQuran,
        icon: PhosphorIconsRegular.bookOpenText,
        activeIcon: PhosphorIconsFill.bookOpenText,
      ),
      DuskNavItem(
        label: l10n.navPrayer,
        icon: PhosphorIconsRegular.clock,
        activeIcon: PhosphorIconsFill.clock,
      ),
      DuskNavItem(
        label: l10n.navTasbih,
        icon: PhosphorIconsRegular.handsPraying,
        activeIcon: PhosphorIconsFill.handsPraying,
      ),
      DuskNavItem(
        label: l10n.navMore,
        icon: PhosphorIconsRegular.squaresFour,
        activeIcon: PhosphorIconsFill.squaresFour,
      ),
    ];

    return Obx(
      () => DuskNavBar(
        items: items,
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
      ),
    );
  }
}
