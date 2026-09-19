import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';

/// What a tracker circle is saying about one prayer on one day.
enum TrackerState {
  /// Logged as prayed.
  done,

  /// The window is open right now — this is the tap the user came to make.
  due,

  /// Still ahead in the day.
  future,

  /// The window closed without a log.
  missed,
}

/// The circle the user taps to log a prayer.
///
/// This is the primary new interaction in the redesign, so it gets the three
/// things a primary interaction needs: an unmistakable resting state per
/// status, a 180ms press that confirms the tap landed, and a haptic.
///
/// The dashed outline for "not yet" is deliberate. An empty solid ring reads as
/// an unchecked box the user is already behind on; a dashed one reads as *not
/// your turn yet*, which is what it actually means at eight in the morning for
/// Isha. Missed keeps the solid muted ring, so the two are not confusable.
class TrackerCircle extends StatefulWidget {
  const TrackerCircle({
    super.key,
    required this.state,
    this.onTap,
    this.size = AppValues.trackerCircle,
    this.semanticLabel,
  });

  final TrackerState state;
  final VoidCallback? onTap;
  final double size;
  final String? semanticLabel;

  /// The compact variant used in the নামাজ list rows. It carries no glyph — at
  /// 30px a glyph is noise, and the row's own text already names the prayer.
  bool get compact => size <= AppValues.trackerCircleSmall;

  @override
  State<TrackerCircle> createState() => _TrackerCircleState();
}

class _TrackerCircleState extends State<TrackerCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppValues.trackerTap,
    lowerBound: 0.92,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    final onTap = widget.onTap;
    if (onTap == null) return;
    HapticFeedback.selectionClick();
    await _controller.reverse();
    if (!mounted) return;
    _controller.forward();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final tappable = widget.onTap != null;
    final dashed = widget.state == TrackerState.future;

    Widget circle = AnimatedContainer(
      duration: AppValues.trackerTap,
      curve: Curves.easeOut,
      width: widget.size,
      height: widget.size,
      decoration: _decoration,
      alignment: Alignment.center,
      child: widget.compact ? null : _icon,
    );

    if (dashed) {
      circle = CustomPaint(
        painter: const _DashedRingPainter(color: AppColors.dashedBorder),
        child: circle,
      );
    }

    return Semantics(
      button: tappable,
      checked: widget.state == TrackerState.done,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: tappable ? _handleTap : null,
        child: ScaleTransition(scale: _controller, child: circle),
      ),
    );
  }

  BoxDecoration get _decoration {
    switch (widget.state) {
      case TrackerState.done:
        return const BoxDecoration(
          color: AppColors.duskMid,
          shape: BoxShape.circle,
        );

      case TrackerState.due:
        // On হোম the due circle is a filled gold call to action. In the নামাজ
        // list it is a gold ring instead: a solid gold dot in a row of six
        // would out-shout the row it belongs to.
        return widget.compact
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              )
            : const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              );

      case TrackerState.missed:
        return BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.dashedBorder, width: 2),
        );

      case TrackerState.future:
        // The ring is painted by _DashedRingPainter, so the box itself is bare.
        return const BoxDecoration(shape: BoxShape.circle);
    }
  }

  Widget? get _icon {
    switch (widget.state) {
      case TrackerState.done:
        return const Icon(
          PhosphorIconsRegular.check,
          size: AppValues.icon_20,
          color: AppColors.onDeepPrimary,
        );
      case TrackerState.due:
        return const Icon(
          PhosphorIconsRegular.plus,
          size: AppValues.icon_21,
          color: AppColors.goldInk,
        );
      case TrackerState.future:
      case TrackerState.missed:
        return const Icon(
          PhosphorIconsRegular.minus,
          size: AppValues.icon_18,
          color: AppColors.inkMuted,
        );
    }
  }
}

/// A dashed ring. Flutter has no dashed border, and the "not yet" state needs
/// one at both 44px and 30px, so it is painted.
class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({required this.color});

  final Color color;

  static const double strokeWidth = 2;
  static const double dashLength = 4;
  static const double gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - strokeWidth) / 2;
    if (radius <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final circumference = 2 * math.pi * radius;
    final segment = dashLength + gapLength;

    // Round the dash count so the ring closes cleanly rather than leaving a
    // ragged join at twelve o'clock.
    final count = (circumference / segment).round().clamp(6, 64);
    final sweep = 2 * math.pi / count;
    final dashSweep = sweep * (dashLength / segment);

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
    for (var i = 0; i < count; i++) {
      canvas.drawArc(rect, i * sweep, dashSweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) => old.color != color;
}
