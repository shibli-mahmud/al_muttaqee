import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';

/// The primary action button.
///
/// The label sits flush left with the icon pushed to the far right by a
/// [Spacer], rather than the pair being centred together. On a full-width
/// button that puts the words where the eye already is after reading the screen
/// and turns the icon into a direction-of-travel marker instead of decoration.
class DuskPrimaryButton extends StatelessWidget {
  const DuskPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.background = AppColors.gold,
    this.foreground = AppColors.goldInk,
    this.shadow = AppColors.shadowGold,
    this.radius = DuskRadius.card,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final List<BoxShadow> shadow;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(radius),
            // A disabled button carries no shadow — the lift is what says
            // "press me", so it has to go when pressing does nothing.
            boxShadow: enabled ? shadow : const [],
          ),
          child: InkWell(
            onTap: onPressed,
            highlightColor: AppColors.goldPressed.withValues(alpha: 0.5),
            splashColor: AppColors.goldPressed.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppValues.fontSize_17,
                horizontal: AppValues.space_22,
              ),
              child: Row(
                children: [
                  Text(
                    label,
                    style: DuskText.button.copyWith(color: foreground),
                  ),
                  if (icon != null) ...[
                    const Spacer(),
                    Icon(icon, size: AppValues.icon_20, color: foreground),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The secondary action: a white card that reads as a button because it sits
/// under a primary one, not because it is outlined.
class DuskSecondaryButton extends StatelessWidget {
  const DuskSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingText,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;

  /// A hint at the trailing edge — `ঢাকা, চট্টগ্রাম…` on the location fallback.
  final String? trailingText;

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DuskRadius.card),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(DuskRadius.card),
            boxShadow: enabled ? AppColors.shadowCard : const [],
          ),
          child: InkWell(
            onTap: onPressed,
            splashColor: AppColors.sage.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppValues.fontSize_17,
                horizontal: AppValues.space_22,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: AppValues.icon_19,
                      color: AppColors.duskMid,
                    ),
                    const SizedBox(width: AppValues.space_11),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: DuskText.buttonSecondary
                          .copyWith(color: AppColors.inkSecondary),
                    ),
                  ),
                  if (trailingText != null)
                    Text(
                      trailingText!,
                      style: DuskText.rowTrailing
                          .copyWith(color: AppColors.inkMuted),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A text action that reads as a link — `সেটিংসে যান` inside a warning panel.
class DuskLinkButton extends StatelessWidget {
  const DuskLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.goldOnIvory,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.gap_6),
        child: Text(
          label,
          style: DuskText.bangla(
            size: AppValues.fontSize_13,
            weight: FontWeight.w700,
            color: color,
          ).copyWith(
            decoration: TextDecoration.underline,
            decorationColor: color,
          ),
        ),
      ),
    );
  }
}
