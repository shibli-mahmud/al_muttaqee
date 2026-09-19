import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';

/// The compass face.
///
/// The dial turns and the phone does not: the ring of degrees and cardinals
/// rotates under a fixed needle, the way a real compass card floats under the
/// lubber line. The alternative — spinning the needle over a fixed card — is
/// what a lot of qibla apps do and it reads backwards, because the thing that
/// is actually moving is you.
///
/// Everything is painted rather than assembled from widgets. A compass is a
/// hundred tick marks that all rotate together; as widgets that is a hundred
/// transforms a frame, and as a canvas it is one.
class QiblaDial extends StatelessWidget {
  const QiblaDial({
    super.key,
    required this.heading,
    required this.qiblaBearing,
    required this.closeness,
    required this.aligned,
  });

  /// Device heading in degrees, already smoothed.
  final double heading;

  /// Bearing to the Kaaba in degrees from true north.
  final double qiblaBearing;

  /// 0 when side-on, 1 when facing the qibla.
  final double closeness;

  final bool aligned;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _DialPainter(
          heading: heading,
          qiblaBearing: qiblaBearing,
          closeness: closeness,
          aligned: aligned,
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.heading,
    required this.qiblaBearing,
    required this.closeness,
    required this.aligned,
  });

  final double heading;
  final double qiblaBearing;
  final double closeness;
  final bool aligned;

  static const Color _ring = Color(0xFF9EC4BC);
  static const Color _faint = Color(0xFFA8C2BC);

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final outer = size.shortestSide / 2;

    // The design's 300 / 238 / 170 on a 390 frame, kept as ratios so the dial
    // scales with the screen instead of being pinned to one phone.
    final r1 = outer * 0.98;
    final r2 = outer * 0.78;
    final r3 = outer * 0.56;

    _paintRings(canvas, centre, r1, r2, r3);

    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    // Rotating by minus the heading is what makes the card float: turn the
    // phone right and north swings left, staying put in the world.
    canvas.rotate(-heading * math.pi / 180);
    canvas.translate(-centre.dx, -centre.dy);

    _paintTicks(canvas, centre, r1);
    _paintCardinals(canvas, centre, r1);
    _paintQiblaMarker(canvas, centre, r1);

    canvas.restore();

    _paintNeedle(canvas, centre, r2);
  }

  void _paintRings(
    Canvas canvas,
    Offset centre,
    double r1,
    double r2,
    double r3,
  ) {
    canvas.drawCircle(
      centre,
      r1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _ring.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      centre,
      r2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _ring.withValues(alpha: 0.22),
    );

    // The inner disc lifts as the user comes onto the bearing, so the middle
    // of the dial brightens with the turn.
    canvas.drawCircle(
      centre,
      r3,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05 + 0.05 * closeness),
    );

    if (aligned) {
      canvas.drawCircle(
        centre,
        r3,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = AppColors.gold.withValues(alpha: 0.55),
      );
    }
  }

  /// A tick every 5°, longer every 30°.
  void _paintTicks(Canvas canvas, Offset centre, double radius) {
    for (var degree = 0; degree < 360; degree += 5) {
      final major = degree % 30 == 0;
      final angle = (degree - 90) * math.pi / 180;

      final length = major ? radius * 0.075 : radius * 0.04;
      final from = Offset(
        centre.dx + (radius - length) * math.cos(angle),
        centre.dy + (radius - length) * math.sin(angle),
      );
      final to = Offset(
        centre.dx + radius * math.cos(angle),
        centre.dy + radius * math.sin(angle),
      );

      canvas.drawLine(
        from,
        to,
        Paint()
          ..strokeWidth = major ? 1.6 : 1
          ..strokeCap = StrokeCap.round
          ..color = _faint.withValues(alpha: major ? 0.55 : 0.28),
      );
    }
  }

  void _paintCardinals(Canvas canvas, Offset centre, double radius) {
    const labels = {0: 'N', 90: 'E', 180: 'S', 270: 'W'};
    final inset = radius * 0.845;

    labels.forEach((degree, label) {
      final north = degree == 0;
      final angle = (degree - 90) * math.pi / 180;
      final at = Offset(
        centre.dx + inset * math.cos(angle),
        centre.dy + inset * math.sin(angle),
      );

      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: DuskText.latin(
            size: 13,
            weight: north ? FontWeight.w800 : FontWeight.w700,
            color: north ? AppColors.gold : _faint,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(at.dx, at.dy);
      // Counter-rotate, so the letters stay upright as the card turns.
      canvas.rotate(heading * math.pi / 180);
      painter.paint(
        canvas,
        Offset(-painter.width / 2, -painter.height / 2),
      );
      canvas.restore();
    });
  }

  /// The Kaaba, sitting on the outer ring at its true bearing.
  void _paintQiblaMarker(Canvas canvas, Offset centre, double radius) {
    final angle = (qiblaBearing - 90) * math.pi / 180;
    final at = Offset(
      centre.dx + radius * math.cos(angle),
      centre.dy + radius * math.sin(angle),
    );
    final markerRadius = radius * 0.085;

    canvas.drawCircle(
      at,
      markerRadius * 1.7,
      Paint()..color = AppColors.gold.withValues(alpha: 0.18 + 0.25 * closeness),
    );
    canvas.drawCircle(at, markerRadius, Paint()..color = AppColors.gold);

    // A small Kaaba: a cube with its kiswah band. Simple geometry rather than
    // an icon, so it stays crisp at any dial size and matches the app's
    // drawn-not-illustrated rule.
    final side = markerRadius * 0.86;
    final cube = Rect.fromCenter(center: at, width: side, height: side * 1.05);
    canvas.drawRRect(
      RRect.fromRectAndRadius(cube, const Radius.circular(1.5)),
      Paint()..color = AppColors.goldInk,
    );
    canvas.drawLine(
      Offset(cube.left, at.dy - side * 0.12),
      Offset(cube.right, at.dy - side * 0.12),
      Paint()
        ..strokeWidth = math.max(side * 0.13, 1)
        ..color = AppColors.gold,
    );
  }

  /// The fixed needle, pointing up the screen.
  ///
  /// It does not rotate — the dial does. Its job is to say "this way is where
  /// the phone is pointing", and it goes gold once that is the qibla.
  void _paintNeedle(Canvas canvas, Offset centre, double radius) {
    final length = radius * 0.86;
    final width = 3.0 + 1.5 * closeness;
    final colour = aligned ? AppColors.gold : AppColors.goldBright;

    final rect = Rect.fromLTWH(
      centre.dx - width / 2,
      centre.dy - length,
      width,
      length,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(width)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colour.withValues(alpha: 0.35 + 0.65 * closeness),
            colour.withValues(alpha: 0.15),
          ],
        ).createShader(rect),
    );

    // The pivot, which also hides the needle's blunt end.
    canvas.drawCircle(
      centre,
      6,
      Paint()..color = aligned ? AppColors.gold : AppColors.onDeepMuted,
    );
    canvas.drawCircle(
      centre,
      2.5,
      Paint()..color = AppColors.duskDeep,
    );
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.heading != heading ||
      old.qiblaBearing != qiblaBearing ||
      old.closeness != closeness ||
      old.aligned != aligned;
}
