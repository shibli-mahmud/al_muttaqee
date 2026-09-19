import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk_hero.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk_states.dart';

/// A destination that is designed but not yet built.
///
/// The আরও grid shows every feature the app will have, including the ones
/// still ahead. Tapping one lands here rather than on a dead tile: a tile that
/// does nothing reads as a bug, while a screen that says "coming soon" reads as
/// a promise. The hero keeps it inside the app's chrome so it does not feel
/// like an error page.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          DuskHero(
            theme: DuskHeroTheme.day,
            child: DuskHeroTitleRow(
              title: title,
              theme: DuskHeroTheme.day,
              onBack: Get.back,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.space_34,
                ),
                child: DuskEmptyState(
                  icon: icon,
                  message: l10n.comingSoonBody,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The placeholder used by routes whose screens land in a later phase.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({
    super.key,
    required this.titleBuilder,
    this.icon = PhosphorIconsRegular.sparkle,
  });

  final String Function(AppLocalizations l10n) titleBuilder;
  final IconData icon;

  @override
  Widget build(BuildContext context) => ComingSoonView(
        title: titleBuilder(AppLocalizations.of(context)!),
        icon: icon,
      );
}
