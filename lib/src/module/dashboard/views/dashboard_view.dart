import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:al_muttaqee/src/module/home/views/home_view.dart';
import 'package:al_muttaqee/src/module/qibla/views/qibla_view.dart';
import 'package:al_muttaqee/src/module/quran/views/quran_view.dart';
import 'package:al_muttaqee/src/module/tasbih/views/tasbih_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardView extends BaseView<DashboardController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    final List<Widget> pages = [
      HomeView(),
      QuranView(),
      QiblaView(),
      TasbihView(),
    ];
    return Obx(() => pages[controller.currentIndex.value]);
  }

  @override
  Widget? drawer() {
    return _LanguageDrawer();
  }

  @override
  Widget? bottomNavigationBar() {
    final l10n = appLocalization;
    return Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.baseBlack,
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        selectedItemColor: AppColors.brand100,
        unselectedItemColor: AppColors.baseWhite,
        showUnselectedLabels: true,
        selectedFontSize: AppValues.fontSize_10,
        unselectedFontSize: AppValues.fontSize_10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.house, size: AppValues.icon),
            activeIcon: Icon(PhosphorIconsFill.house, size: AppValues.icon),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.bookOpenText, size: AppValues.icon),
            activeIcon:
                Icon(PhosphorIconsFill.bookOpenText, size: AppValues.icon),
            label: l10n.quran,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.compass, size: AppValues.icon),
            activeIcon: Icon(PhosphorIconsFill.compass, size: AppValues.icon),
            label: l10n.qibla,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.handsPraying, size: AppValues.icon),
            activeIcon:
                Icon(PhosphorIconsFill.handsPraying, size: AppValues.icon),
            label: l10n.tasbih,
          ),
        ],
      ),
    );
  }
}

class _LanguageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.brand800,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.english),
              onTap: () async {
                Navigator.of(context).pop();
                await L10n.setLocale(const Locale('en'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.bangla),
              onTap: () async {
                Navigator.of(context).pop();
                await L10n.setLocale(const Locale('bn'));
              },
            ),
          ],
        ),
      ),
    );
  }
}