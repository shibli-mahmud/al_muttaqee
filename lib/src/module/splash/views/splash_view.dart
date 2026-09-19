import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/khatim_pattern.dart';
import 'package:al_muttaqee/src/module/splash/controllers/splash_controller.dart';

/// The launch screen.
///
/// The same mark as the launcher icon and onboarding frame ০৯, on the hero
/// gradient, so the first thing the user sees is already the app rather than a
/// white card with clip art on it.
class SplashView extends BaseView<SplashController> {
  SplashView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.duskDeep;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  @override
  Widget body(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: DuskHeroTheme.day.decoration),
      child: Stack(
        children: [
          const KhatimOverlay(ink: AppColors.onDeepPrimary, opacity: 0.14),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppValues.container_72 + 12,
                  height: AppValues.container_72 + 12,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppValues.space_28),
                  ),
                  alignment: Alignment.center,
                  // The glyph, not the full mark — the plate is the container
                  // above, so the app can colour the two independently.
                  child: Image.asset(
                    'assets/images/brand_glyph.png',
                    width: AppValues.icon_50,
                    height: AppValues.icon_50,
                  ),
                ),
                const SizedBox(height: AppValues.space_22),
                Text(
                  'المتقي',
                  style: DuskText.arabicWordmark
                      .copyWith(color: AppColors.goldBright),
                ),
                Text(
                  'আল মুত্তাকী',
                  style: DuskText.bangla(
                    size: AppValues.fontSize_32,
                    weight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.onDeepPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
