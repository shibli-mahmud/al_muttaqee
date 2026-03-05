import 'dart:math' as math;

import 'package:al_muttaqee/src/module/tasbih/controllers/tasbih_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum _BeadsOrientation { horizontal, vertical }

/// Minimum swipe distance (px) to count as one bead move.
const double _kMinSwipeDistance = 36;

class TasbihView extends BaseView<TasbihController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.gapLarge,
        vertical: AppValues.gap,
      ),
      height: double.infinity,
      width: double.infinity,
      color: AppColors.baseWhite,
      child: Obx(() => _TasbihContent(
            count: controller.count.value,
            totalCount: controller.totalCount.value,
            roundsCompleted: controller.roundsCompleted.value,
            targetCount: TasbihController.targetCount,
            l10n: appLocalization,
            onIncrement: controller.increment,
            onDecrement: controller.decrement,
            onSwipeEnd: controller.completeRoundIfFull,
            onResetRound: controller.resetRound,
            onResetAll: controller.resetAll,
          )),
    );
  }
}

class _TasbihContent extends StatefulWidget {
  const _TasbihContent({
    required this.count,
    required this.totalCount,
    required this.roundsCompleted,
    required this.targetCount,
    required this.l10n,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSwipeEnd,
    required this.onResetRound,
    required this.onResetAll,
  });

  final int count;
  final int totalCount;
  final int roundsCompleted;
  final int targetCount;
  final AppLocalizations l10n;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onSwipeEnd;
  final VoidCallback onResetRound;
  final VoidCallback onResetAll;

  @override
  State<_TasbihContent> createState() => _TasbihContentState();
}

class _TasbihContentState extends State<_TasbihContent> {
  _BeadsOrientation _orientation = _BeadsOrientation.horizontal;

  @override
  Widget build(BuildContext context) {
    final hasCount = widget.count > 0 || widget.totalCount > 0;

    return Column(
      children: [
        const SizedBox(height: AppValues.gapSmall),
        Text(
          '${widget.count} / ${widget.targetCount}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (widget.roundsCompleted > 0) ...[
          const SizedBox(height: AppValues.gap_4),
          Text(
            widget.l10n.tasbihRoundsTotal(
                widget.roundsCompleted, widget.totalCount),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
        const SizedBox(height: AppValues.gap),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _BeadsWindow(
                count: widget.count,
                targetCount: widget.targetCount,
                orientation: _orientation,
                constraints: constraints.biggest,
                onIncrement: widget.onIncrement,
                onDecrement: widget.onDecrement,
                onSwipeEnd: widget.onSwipeEnd,
              );
            },
          ),
        ),
        const SizedBox(height: AppValues.gapXSmall),
        Text(
          _orientation == _BeadsOrientation.horizontal
              ? widget.l10n.tasbihSwipeHorizontal
              : widget.l10n.tasbihSwipeVertical,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
        ),
        const SizedBox(height: AppValues.gap),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _OrientationChip(
              icon: PhosphorIconsRegular.arrowsHorizontal,
              label: widget.l10n.tasbihOrientationLeftRight,
              selected: _orientation == _BeadsOrientation.horizontal,
              onTap: () {
                setState(() {
                  _orientation = _BeadsOrientation.horizontal;
                });
              },
            ),
            const SizedBox(width: AppValues.gap),
            _OrientationChip(
              icon: PhosphorIconsRegular.arrowsVertical,
              label: widget.l10n.tasbihOrientationUpDown,
              selected: _orientation == _BeadsOrientation.vertical,
              onTap: () {
                setState(() {
                  _orientation = _BeadsOrientation.vertical;
                });
              },
            ),
          ],
        ),
        if (hasCount) ...[
          const SizedBox(height: AppValues.gap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: PhosphorIconsRegular.arrowCounterClockwise,
                label: widget.l10n.tasbihResetRound,
                onTap: widget.onResetRound,
              ),
              const SizedBox(width: AppValues.gap),
              _ActionButton(
                icon: PhosphorIconsRegular.trash,
                label: widget.l10n.tasbihResetAll,
                onTap: widget.onResetAll,
              ),
            ],
          ),
        ],
        const SizedBox(height: AppValues.gapLarge),
      ],
    );
  }
}

class _OrientationChip extends StatelessWidget {
  const _OrientationChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brand200 : AppColors.grey200,
      borderRadius: BorderRadius.circular(AppValues.radiusLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppValues.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.gap,
            vertical: AppValues.gapXSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppValues.icon_18,
                color: selected ? AppColors.brand800 : AppColors.grey700,
              ),
              const SizedBox(width: AppValues.gap_4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: selected ? AppColors.brand800 : AppColors.grey700,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows 4 beads: [count-1, count, count+1, count+2]. Center bead is current (full size/opacity), edges faded.
class _BeadsWindow extends StatefulWidget {
  const _BeadsWindow({
    required this.count,
    required this.targetCount,
    required this.orientation,
    required this.constraints,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSwipeEnd,
  });

  final int count;
  final int targetCount;
  final _BeadsOrientation orientation;
  final Size constraints;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onSwipeEnd;

  static const int _visibleBeads = 4;
  static const double _stringThickness = 2.5;
  static const double _centerBeadScale = 1.0;
  static const double _sideBeadScale = 0.72;
  static const double _edgeBeadScale = 0.52;

  @override
  State<_BeadsWindow> createState() => _BeadsWindowState();
}

class _BeadsWindowState extends State<_BeadsWindow>
    with SingleTickerProviderStateMixin {
  /// Total drag distance during current gesture (for one-swipe-one-bead).
  double _totalDragDelta = 0;
  /// One bead step in pixels (baseSize + gap), updated in build.
  double _oneBeadStep = 60;
  /// +1 = forward animation, -1 = backward.
  int _beadMoveDirection = 0;
  late AnimationController _beadMoveController;

  static const double _totalExtentFactor = 4.0 + 3 * 0.35;

  @override
  void initState() {
    super.initState();
    _beadMoveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _beadMoveController.dispose();
    super.dispose();
  }

  void _startOneBeadAnimation(int direction) {
    if (_beadMoveController.isAnimating) return;
    _beadMoveDirection = direction;
    void onComplete(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _beadMoveController.removeStatusListener(onComplete);
        _beadMoveController.reset();
        if (_beadMoveDirection > 0) {
          widget.onIncrement();
        } else {
          widget.onDecrement();
        }
        widget.onSwipeEnd();
        _beadMoveDirection = 0;
        setState(() {});
      }
    }
    _beadMoveController.addStatusListener(onComplete);
    _beadMoveController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        widget.orientation == _BeadsOrientation.horizontal;
    final extent =
        isHorizontal ? widget.constraints.width : widget.constraints.height;
    final crossExtent =
        isHorizontal ? widget.constraints.height : widget.constraints.width;
    final maxBaseFromExtent = extent / _totalExtentFactor;
    final maxBaseFromCross = crossExtent * 0.32;
    final baseSize =
        math.min(math.min(maxBaseFromExtent, maxBaseFromCross), 80.0)
            .clamp(32.0, 80.0);
    final gap = baseSize * 0.35;
    _oneBeadStep = baseSize + gap;

    final double dragOffset = _beadMoveController.isAnimating
        ? _beadMoveDirection * _oneBeadStep * Curves.easeOut.transform(_beadMoveController.value)
        : 0;
    final offset = isHorizontal
        ? Offset(dragOffset, 0)
        : Offset(0, dragOffset);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (_) {
        _totalDragDelta = 0;
      },
      onPanUpdate: (details) {
        final delta = isHorizontal ? details.delta.dx : details.delta.dy;
        _totalDragDelta += delta;
      },
      onPanEnd: (_) {
        if (_totalDragDelta >= _kMinSwipeDistance && !_beadMoveController.isAnimating) {
          HapticFeedback.selectionClick();
          _startOneBeadAnimation(1);
        } else if (_totalDragDelta <= -_kMinSwipeDistance && !_beadMoveController.isAnimating) {
          HapticFeedback.selectionClick();
          _startOneBeadAnimation(-1);
        } else {
          widget.onSwipeEnd();
        }
        _totalDragDelta = 0;
      },
      child: SizedBox(
        width: widget.constraints.width,
        height: widget.constraints.height,
        child: Center(
          child: ClipRect(
            child: Transform.translate(
              offset: offset,
              child: isHorizontal
                  ? _buildHorizontalBeads(baseSize, gap)
                  : _buildVerticalBeads(baseSize, gap),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalBeads(double baseSize, double gap) {
    final beads = _buildBeadSlots(baseSize);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _BeadsWindow._visibleBeads; i++) ...[
          if (i > 0) _StringSegment(gap: gap, horizontal: true),
          beads[i],
        ],
      ],
    );
  }

  Widget _buildVerticalBeads(double baseSize, double gap) {
    final beads = _buildBeadSlots(baseSize);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _BeadsWindow._visibleBeads; i++) ...[
          if (i > 0) _StringSegment(gap: gap, horizontal: false),
          beads[i],
        ],
      ],
    );
  }

  List<Widget> _buildBeadSlots(double baseSize) {
    const c = _BeadsWindow._visibleBeads;
    final count = widget.count;
    final target = widget.targetCount;
    final slots = <Widget>[];
    for (int i = 0; i < c; i++) {
      final value = count - 1 + i;
      final isCurrent = i == 1;
      final isPast = value < 0;
      final isFuture = value > target;
      double scale;
      double opacity;
      if (isCurrent) {
        scale = _BeadsWindow._centerBeadScale;
        opacity = 1.0;
      } else if (i == 0 || i == c - 1) {
        scale = _BeadsWindow._edgeBeadScale;
        opacity = (isPast || isFuture) ? 0.25 : 0.45;
      } else {
        scale = _BeadsWindow._sideBeadScale;
        opacity = (isPast || isFuture) ? 0.3 : 0.6;
      }
      slots.add(
        _WindowBead(
          size: baseSize * scale,
          counted: value >= 0 && value < count,
          isCurrent: isCurrent,
          faded: isPast || isFuture,
          opacity: opacity,
          showCheck: value == target && value < count,
        ),
      );
    }
    return slots;
  }
}

class _StringSegment extends StatelessWidget {
  const _StringSegment({required this.gap, required this.horizontal});

  final double gap;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: horizontal ? gap : _BeadsWindow._stringThickness,
      height: horizontal ? _BeadsWindow._stringThickness : gap,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(_BeadsWindow._stringThickness / 2),
      ),
    );
  }
}

class _WindowBead extends StatelessWidget {
  const _WindowBead({
    required this.size,
    required this.counted,
    required this.isCurrent,
    required this.faded,
    required this.opacity,
    required this.showCheck,
  });

  final double size;
  final bool counted;
  final bool isCurrent;
  final bool faded;
  final double opacity;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final color = faded
        ? AppColors.grey400
        : (counted ? AppColors.brand500 : AppColors.brand300);
    final borderColor =
        faded ? AppColors.grey500 : (counted ? AppColors.brand700 : AppColors.brand500);

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: borderColor,
            width: isCurrent ? 2.5 : 1.5,
          ),
          boxShadow: isCurrent && !faded
              ? [
                  BoxShadow(
                    color: AppColors.brand600.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: showCheck
            ? Icon(
                PhosphorIconsFill.check,
                size: size * 0.45,
                color: AppColors.baseWhite,
              )
            : null,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppValues.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.gap,
            vertical: AppValues.gapXSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppValues.icon_20, color: AppColors.brand600),
              const SizedBox(width: AppValues.gap_4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.brand700,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
