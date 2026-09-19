import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The eight-point *khatim* star texture that sits inside every hero.
///
/// The tile is two 28×28 squares sharing a centre, one turned 45°, stroked and
/// unfilled, repeated on a 56px grid.
///
/// This is drawn rather than tiled from a PNG. The handoff offers both, and the
/// painter wins here for one reason: [DuskHeroTheme.patternInk] changes with
/// the time of day — ivory on the teal and midnight heroes, warm cream on the
/// Maghrib and Ramadan ones — and a raster tile would need a separate asset per
/// ink. Two stroked rectangles per tile is cheap enough that recolouring for
/// free is the better trade.
class KhatimPainter extends CustomPainter {
  const KhatimPainter({
    required this.ink,
    this.opacity = 0.13,
    this.tile = 56,
    this.strokeWidth = 1.1,
  });

  /// Stroke colour of the star. Comes from the active hero theme.
  final Color ink;

  /// 0.12 on most heroes, 0.14–0.16 on onboarding and Ramadan.
  final double opacity;

  final double tile;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || opacity <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = ink.withValues(alpha: opacity);

    // The square is half the tile, centred in it — the same 14/28/56 geometry
    // as the SVG in the handoff bundle.
    final inset = tile / 4;
    final side = tile / 2;
    final square = Rect.fromLTWH(inset, inset, side, side);
    final centre = Offset(tile / 2, tile / 2);

    final columns = (size.width / tile).ceil();
    final rows = (size.height / tile).ceil();

    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        canvas.save();
        canvas.translate(column * tile, row * tile);

        canvas.drawRect(square, paint);

        canvas.translate(centre.dx, centre.dy);
        canvas.rotate(math.pi / 4);
        canvas.translate(-centre.dx, -centre.dy);
        canvas.drawRect(square, paint);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(KhatimPainter old) =>
      old.ink != ink ||
      old.opacity != opacity ||
      old.tile != tile ||
      old.strokeWidth != strokeWidth;
}

/// The khatim texture as a fill, for dropping into a [Stack] above a gradient
/// and below the content. Clip the stack, not this — the pattern has to be cut
/// by the hero's bottom radius.
class KhatimOverlay extends StatelessWidget {
  const KhatimOverlay({
    super.key,
    required this.ink,
    this.opacity = 0.13,
  });

  final Color ink;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: KhatimPainter(ink: ink, opacity: opacity),
        ),
      ),
    );
  }
}
