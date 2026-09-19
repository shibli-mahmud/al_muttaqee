import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';

/// One destination in [DuskNavBar].
class DuskNavItem {
  const DuskNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// The floating bottom navigation bar.
///
/// Five equal cells inside a deep-teal pill. The active cell fills gold across
/// its whole width — not a bar, not an underline — which is legible at arm's
/// length in a way a tinted icon is not. Labels stay at every width: they are
/// four to six Bangla characters and the audience includes users 45+, for whom
/// an unlabelled glyph row is a guessing game.
class DuskNavBar extends StatelessWidget {
  const DuskNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DuskNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < AppValues.breakpointNarrow;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppValues.navOuterH,
          AppValues.navOuterTop,
          AppValues.navOuterH,
          AppValues.navOuterBottom,
        ),
        child: _bar(narrow),
      ),
    );
  }

  Widget _bar(bool narrow) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.duskDeep,
        borderRadius: BorderRadius.circular(DuskRadius.nav),
        boxShadow: AppColors.shadowNav,
      ),
      padding: EdgeInsets.all(
        narrow ? AppValues.gap_6 : AppValues.navInnerPadding,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _NavCell(
                item: items[i],
                active: i == currentIndex,
                narrow: narrow,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({
    required this.item,
    required this.active,
    required this.narrow,
    required this.onTap,
  });

  final DuskNavItem item;
  final bool active;
  final bool narrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSize = narrow ? AppValues.icon_19 : AppValues.icon_20;

    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DuskRadius.navPill),
        child: AnimatedContainer(
          duration: AppValues.navPill,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            vertical: narrow ? AppValues.gap_6 : AppValues.navInnerPadding,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(DuskRadius.navPill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? item.activeIcon : item.icon,
                size: iconSize,
                color: active ? AppColors.goldInk : AppColors.onDeepMuted,
              ),
              const SizedBox(height: AppValues.space_3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: (active ? DuskText.navLabelActive : DuskText.navLabel)
                    .copyWith(
                  color: active ? AppColors.goldInk : AppColors.onDeepMuted,
                  fontSize: narrow
                      ? AppValues.fontSize_10
                      : AppValues.fontSize_10_5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
