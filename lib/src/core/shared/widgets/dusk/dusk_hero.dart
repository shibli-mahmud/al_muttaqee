import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/khatim_pattern.dart';

/// The shared header on most Dusk screens: a gradient sheet with rounded
/// bottom corners, the khatim texture over it, and screen content on top.
///
/// The gradient is not decoration — it tracks the time of day, so the app looks
/// different at Fajr than it does at Maghrib and the user can tell at a glance
/// roughly where in the day they are. The window turnover cross-fades over
/// 400ms so it never snaps mid-glance.
class DuskHero extends StatelessWidget {
  const DuskHero({
    super.key,
    required this.theme,
    required this.child,
    this.bottomRadius = DuskRadius.hero,
    this.paddingBottom = AppValues.space_20,
  });

  final DuskHeroTheme theme;

  /// Hero content. Already inside the top [SafeArea] and the clip.
  final Widget child;

  /// 30 on হোম, 28 elsewhere. Bottom corners only — a hero is a sheet that has
  /// slid down from off-screen, so its top corners are never visible.
  final double bottomRadius;

  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.vertical(bottom: Radius.circular(bottomRadius));

    return ClipRRect(
      borderRadius: radius,
      child: AnimatedContainer(
        duration: AppValues.heroCrossFade,
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(gradient: theme.decoration),
        child: Stack(
          children: [
            KhatimOverlay(ink: theme.patternInk, opacity: theme.patternOpacity),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: paddingBottom),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A 36×36 rounded-square button for the hero's title row.
///
/// Its visible box is smaller than the 44px tap floor, so the hit area is
/// expanded rather than the box grown — the design's rhythm survives and the
/// target still clears the floor.
class DuskHeroIconButton extends StatelessWidget {
  const DuskHeroIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.theme,
    this.size = AppValues.heroIconButton,
    this.iconSize = AppValues.icon_18,
    this.filled = false,
    this.badge = false,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final DuskHeroTheme theme;
  final double size;
  final double iconSize;

  /// Renders the button in the accent colour — used for an *active* toggle,
  /// such as haptics-on in the tasbih hero.
  final bool filled;

  /// A small accent dot at the top-right, for unread notifications.
  final bool badge;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = size >= AppValues.heroBellButton
        ? DuskRadius.iconChipLarge
        : DuskRadius.iconChip + 1;

    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled
            ? theme.accent
            : AppColors.onDeepPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: filled ? theme.accentInk : theme.onPrimary,
      ),
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: AppValues.minTapTarget,
          height: AppValues.minTapTarget,
          child: Center(
            child: badge
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      button,
                      Positioned(
                        top: AppValues.space_9,
                        right: AppValues.space_10,
                        child: Container(
                          width: AppValues.space_7,
                          height: AppValues.space_7,
                          decoration: BoxDecoration(
                            color: theme.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  )
                : button,
          ),
        ),
      ),
    );
  }
}

/// The title row that opens a pushed hero: back arrow, title, optional actions.
class DuskHeroTitleRow extends StatelessWidget {
  const DuskHeroTitleRow({
    super.key,
    required this.title,
    required this.theme,
    this.onBack,
    this.actions = const [],
    this.large = false,
  });

  final String title;
  final DuskHeroTheme theme;

  /// Omit on a tab root — those heroes carry a title with no way back.
  final VoidCallback? onBack;

  final List<Widget> actions;

  /// 21/700 for a tab root, 19/700 when a back arrow shares the row.
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.heroPadding,
        AppValues.gap_6,
        AppValues.heroPadding,
        0,
      ),
      child: Row(
        children: [
          if (onBack != null)
            Padding(
              padding: const EdgeInsets.only(right: AppValues.space_12),
              child: InkResponse(
                onTap: onBack,
                radius: AppValues.space_24,
                child: Icon(
                  PhosphorIconsRegular.arrowLeft,
                  size: AppValues.icon_21,
                  color: theme.onPrimary,
                ),
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: (large ? DuskText.heroTitle : DuskText.heroTitleBack)
                  .copyWith(color: theme.onPrimary),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
