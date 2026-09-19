import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';

/// A plain white card — the default surface for a single piece of content.
class DuskCard extends StatelessWidget {
  const DuskCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppValues.cardPadding,
      horizontal: AppValues.cardPaddingWide,
    ),
    this.radius = DuskRadius.cardTight,
    this.color = AppColors.surface,
    this.border,
    this.shadow = AppColors.shadowCard,
    this.gradient,
    this.onTap,
  });

  /// The selected / highlighted variant: gold-tinted fill with a hairline
  /// border, used for "this is the one" states across the app.
  factory DuskCard.selected({
    Key? key,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(AppValues.cardPadding),
    double radius = DuskRadius.card,
    VoidCallback? onTap,
  }) =>
      DuskCard(
        key: key,
        padding: padding,
        radius: radius,
        color: AppColors.goldTintCard,
        border: Border.all(color: AppColors.goldTintBorder),
        shadow: const [],
        onTap: onTap,
        child: child,
      );

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color color;
  final BoxBorder? border;
  final List<BoxShadow> shadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);

    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: shape,
        border: border,
        boxShadow: shadow,
      ),
      child: child,
    );

    if (onTap == null) return card;

    // The shadow has to stay outside the Material, or the ink splash clips it.
    return Stack(
      children: [
        card,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            borderRadius: shape,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              splashColor: AppColors.sage.withValues(alpha: 0.4),
              highlightColor: AppColors.sage.withValues(alpha: 0.25),
            ),
          ),
        ),
      ],
    );
  }
}

/// A card that groups a run of rows.
///
/// Grouping is done by the card and spacing by padding — there are no dividers
/// anywhere in this design. A rule between every row turns a calm list into a
/// ledger, and at five or six rows the card edge already says where the group
/// starts and stops.
class GroupedCard extends StatelessWidget {
  const GroupedCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppValues.gap_6,
      horizontal: AppValues.gapXSmall,
    ),
    this.radius = DuskRadius.card,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: AppColors.shadowCardRaised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// A row inside a [GroupedCard].
class GroupedRow extends StatelessWidget {
  const GroupedRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.value,
    this.onTap,
    this.tinted = false,
    this.titleStyle,
    this.subtitleStyle,
    this.valueStyle,
    this.chevron = false,
  });

  final String title;
  final String? subtitle;

  /// Usually a [DuskIconChip].
  final Widget? leading;

  /// A widget at the trailing edge — a tracker circle, a switch, a pill.
  final Widget? trailing;

  /// A short trailing value rendered as text, shown before [trailing].
  final String? value;

  final VoidCallback? onTap;

  /// The "this row is next" treatment: gold-tinted fill and hairline border.
  final bool tinted;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? valueStyle;

  final bool chevron;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.rowPaddingV,
        horizontal: AppValues.rowPaddingH,
      ),
      decoration: tinted
          ? BoxDecoration(
              color: AppColors.goldTintCard,
              borderRadius: BorderRadius.circular(DuskRadius.inner),
              border: Border.all(color: AppColors.goldTintBorder),
            )
          : null,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppValues.space_12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ??
                      DuskText.rowTitle.copyWith(
                        color: tinted ? AppColors.goldTintInk : AppColors.ink,
                      ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: subtitleStyle ??
                        (tinted
                            ? DuskText.rowSubtitleStrong
                                .copyWith(color: AppColors.goldOnCanvas)
                            : DuskText.rowSubtitle
                                .copyWith(color: AppColors.inkMuted)),
                  ),
              ],
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: AppValues.gapXSmall),
            Text(
              value!,
              style: valueStyle ??
                  DuskText.rowValue.copyWith(
                    color: tinted ? AppColors.goldTintInk : AppColors.ink,
                  ),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: AppValues.space_12),
            trailing!,
          ],
          if (chevron) ...[
            const SizedBox(width: AppValues.gap_6),
            const Icon(
              PhosphorIconsRegular.caretRight,
              size: AppValues.icon_17,
              color: AppColors.inkMuted,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(DuskRadius.inner),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.sage.withValues(alpha: 0.4),
        highlightColor: AppColors.sage.withValues(alpha: 0.25),
        child: content,
      ),
    );
  }
}

/// The square icon chip that leads a row or heads a tile.
class DuskIconChip extends StatelessWidget {
  const DuskIconChip({
    super.key,
    required this.icon,
    this.size = AppValues.iconChip,
    this.radius = DuskRadius.iconChip,
    this.background = AppColors.sage,
    this.foreground = AppColors.duskMid,
    this.iconSize = AppValues.icon_18,
  });

  final IconData icon;
  final double size;
  final double radius;
  final Color background;
  final Color foreground;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: foreground),
    );
  }
}

/// A rounded pill — streak badges, state chips, filter chips.
class DuskPill extends StatelessWidget {
  const DuskPill({
    super.key,
    required this.label,
    this.icon,
    this.background = AppColors.goldTint,
    this.foreground = AppColors.goldOnCanvas,
    this.border,
    this.onTap,
    this.style,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color? border;
  final VoidCallback? onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.gap_5,
        horizontal: AppValues.space_12,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DuskRadius.chip),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppValues.iconXSmall, color: foreground),
            const SizedBox(width: AppValues.gap_5),
          ],
          Text(
            label,
            style: (style ?? DuskText.chip).copyWith(color: foreground),
          ),
        ],
      ),
    );

    if (onTap == null) return pill;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DuskRadius.chip),
      child: pill,
    );
  }
}

/// A small all-caps-feeling section label above a card or group.
class DuskOverline extends StatelessWidget {
  const DuskOverline(
    this.text, {
    super.key,
    this.color = AppColors.inkMuted,
    this.padding = const EdgeInsets.only(bottom: AppValues.cardGap),
  });

  final String text;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(text, style: DuskText.overline.copyWith(color: color)),
    );
  }
}
