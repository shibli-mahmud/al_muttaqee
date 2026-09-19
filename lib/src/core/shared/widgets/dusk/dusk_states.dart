import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk_buttons.dart';

/// An inline error panel.
///
/// Data failures are never a snackbar in this app. A snackbar leaves the screen
/// showing stale or empty content and then disappears, so the user is left with
/// a broken screen and no explanation. This panel stays where the missing thing
/// should have been, says the cause in plain Bangla, and offers the retry.
class DuskErrorPanel extends StatelessWidget {
  const DuskErrorPanel({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon = PhosphorIconsRegular.warning,
  });

  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.goldTintCard,
        borderRadius: BorderRadius.circular(DuskRadius.card),
        border: Border.all(color: AppColors.goldTintBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppValues.icon_21, color: AppColors.goldOnIvory),
          const SizedBox(width: AppValues.space_13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.gap_4),
                    child: Text(
                      title!,
                      style: DuskText.bangla(
                        size: AppValues.fontSize_14,
                        weight: FontWeight.w700,
                        color: AppColors.goldTintInk,
                      ),
                    ),
                  ),
                Text(
                  message,
                  style: DuskText.bodySmall
                      .copyWith(color: AppColors.goldTintInkSoft),
                ),
                if (actionLabel != null && onAction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppValues.gap_3),
                    child: DuskLinkButton(
                      label: actionLabel!,
                      onPressed: onAction,
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

/// A reassuring status panel — the mirror of [DuskErrorPanel] for when the
/// thing the user was worried about is in fact fine.
class DuskStatusPanel extends StatelessWidget {
  const DuskStatusPanel({
    super.key,
    required this.title,
    required this.message,
    this.icon = PhosphorIconsRegular.shieldCheck,
    this.trailingIcon = PhosphorIconsRegular.checkCircle,
  });

  final String title;
  final String message;
  final IconData icon;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.fontSize_15,
        horizontal: AppValues.cardPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.sage,
        borderRadius: BorderRadius.circular(DuskRadius.card),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppValues.icon_21, color: AppColors.duskMid),
          const SizedBox(width: AppValues.space_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_13_5,
                    weight: FontWeight.w700,
                    color: AppColors.duskDeep,
                  ),
                ),
                Text(
                  message,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_12_5,
                    weight: FontWeight.w400,
                    height: 1.6,
                    color: AppColors.sageInk,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.gapSmall),
          Icon(trailingIcon, size: AppValues.icon_20, color: AppColors.duskMid),
        ],
      ),
    );
  }
}

/// The empty state for a list that has nothing in it yet.
class DuskEmptyState extends StatelessWidget {
  const DuskEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppValues.space_34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppValues.icon_64 + 2,
            height: AppValues.icon_64 + 2,
            decoration: const BoxDecoration(
              color: AppColors.sage,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: AppValues.space_28,
              color: AppColors.duskMid,
            ),
          ),
          const SizedBox(height: AppValues.gap),
          Text(
            message,
            textAlign: TextAlign.center,
            style: DuskText.bodyTight.copyWith(color: AppColors.inkSecondary),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppValues.space_18),
            DuskPrimaryButton(
              label: actionLabel!,
              icon: PhosphorIconsRegular.arrowRight,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}

/// A shimmering placeholder at the final geometry of the thing being loaded.
///
/// The app has no full-screen spinners. A spinner throws away the layout the
/// user is about to read and gives back no sense of how much is coming; a
/// skeleton at the real geometry keeps the page still and makes the wait feel
/// shorter than it is.
class DuskSkeleton extends StatefulWidget {
  const DuskSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius = DuskRadius.gridCell,
  });

  const DuskSkeleton.line({
    super.key,
    this.width = double.infinity,
    this.height = AppValues.gap,
    this.radius = AppValues.gap_6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<DuskSkeleton> createState() => _DuskSkeletonState();
}

class _DuskSkeletonState extends State<DuskSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - t), 0),
              end: Alignment(1 - 2 * (1 - t), 0),
              colors: const [
                AppColors.trackEmpty,
                AppColors.neutralFill,
                AppColors.trackEmpty,
              ],
            ),
          ),
        );
      },
    );
  }
}
