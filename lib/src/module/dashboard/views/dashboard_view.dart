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

class DashboardView extends BaseView<DashboardController>{
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
  Widget? bottomNavigationBar() {
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
        items:  [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.house, size: AppValues.icon),
            activeIcon: Icon(PhosphorIconsFill.house, size: AppValues.icon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.bookOpenText, size: AppValues.icon),
            activeIcon: Icon(PhosphorIconsFill.bookOpenText, size: AppValues.icon),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.compass, size: AppValues.icon),
            activeIcon: Icon(PhosphorIconsFill.compass, size: AppValues.icon),
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.handsPraying, size: AppValues.icon),
            activeIcon: Icon(PhosphorIconsFill.handsPraying, size: AppValues.icon),
            label: 'Tasbih',
          ),
        ],
      ),
    );
  }

}