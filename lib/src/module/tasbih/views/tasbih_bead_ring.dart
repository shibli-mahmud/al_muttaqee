import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';

/// A misbaha — the bead loop, as a widget.
///
/// A tasbih is a physical object with a loop of beads, a marker bead where the
/// count starts, and the feel of one bead clicking past your thumb. A plain
/// number on a card throws all of that away, so this draws the loop instead:
/// beads sit on a ring, the ring turns one bead per count, and the bead under
/// the marker at the top is the one you are on.
///
/// Both gestures work the way the object does. A tap advances one bead. Dragging
/// around the ring rotates it under your thumb and counts the beads that pass,
/// which is how people actually use a misbaha — a continuous pull, not a
/// hundred separate presses.
class TasbihBeadRing extends StatefulWidget {
  const TasbihBeadRing({
    super.key,
    required this.count,
    required this.target,
    required this.onAdvance,
    required this.onRewind,
    required this.child,
  });

  /// Total counted for this dhikr today.
  final int count;

  /// Beads in one round.
  final int target;

  /// One bead forward. Called once per bead, including during a drag.
  final VoidCallback onAdvance;

  /// One bead back, for a miscount.
  final VoidCallback onRewind;

  /// What sits in the middle of the loop — the count itself.
  final Widget child;

  /// How many beads are drawn. A 33-bead ring is the real object; targets of
  /// 100 or 1000 would be an unreadable smear of beads, so the ring stays at a
  /// readable size and the count in the middle carries the total.
  static const int maxBeads = 33;

  @override
  State<TasbihBeadRing> createState() => _TasbihBeadRingState();
}

class _TasbihBeadRingState extends State<TasbihBeadRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late Animation<double> _rotation =
      const AlwaysStoppedAnimation<double>(0);

  /// Where the ring is drawn, in beads. Chases [widget.count] rather than
  /// jumping to it, so a tap reads as a bead rolling past rather than a
  /// redraw.
  double _drawnAt = 0;

  /// Drag accumulator, in beads. Fractional until a whole bead passes.
  double _dragBeads = 0;
  double? _lastDragAngle;

  int get _beads => math.min(
        widget.target <= 0 ? TasbihBeadRing.maxBeads : widget.target,
        TasbihBeadRing.maxBeads,
      );

  @override
  void initState() {
    super.initState();
    _drawnAt = widget.count.toDouble();
    _spin.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(TasbihBeadRing old) {
    super.didUpdateWidget(old);
    if (widget.count != old.count) _animateTo(widget.count.toDouble());
  }

  void _animateTo(double target) {
    _rotation = Tween<double>(begin: _drawnAt, end: target).animate(
      // A touch of overshoot, so the bead settles instead of stopping dead.
      CurvedAnimation(parent: _spin, curve: Curves.easeOutBack),
    );
    _drawnAt = target;
    _spin.forward(from: 0);
  }

  double get _position =>
      _spin.isAnimating ? _rotation.value : _drawnAt;

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  // ── Gestures ──────────────────────────────────────────────────────────────

  void _onPanStart(DragStartDetails details, Size size) {
    _lastDragAngle = _angleOf(details.localPosition, size);
    _dragBeads = 0;
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final angle = _angleOf(details.localPosition, size);
    final previous = _lastDragAngle;
    _lastDragAngle = angle;
    if (previous == null) return;

    // Shortest way round, so crossing twelve o'clock does not register as a
    // full turn backwards.
    var delta = angle - previous;
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;

    _dragBeads += delta / (2 * math.pi / _beads);

    while (_dragBeads >= 1) {
      _dragBeads -= 1;
      widget.onAdvance();
    }
    while (_dragBeads <= -1) {
      _dragBeads += 1;
      widget.onRewind();
    }
  }

  double _angleOf(Offset point, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    return math.atan2(point.dy - centre.dy, point.dx - centre.dx);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxWidth);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onAdvance,
          onPanStart: (d) => _onPanStart(d, size),
          onPanUpdate: (d) => _onPanUpdate(d, size),
          onPanEnd: (_) => _lastDragAngle = null,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: CustomPaint(
              painter: _BeadRingPainter(
                position: _position,
                beads: _beads,
                target: widget.target,
              ),
              child: Center(
                child: Padding(
                  // Keep the number clear of the beads.
                  padding: EdgeInsets.all(size.width * 0.22),
                  child: FittedBox(child: widget.child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BeadRingPainter extends CustomPainter {
  const _BeadRingPainter({
    required this.position,
    required this.beads,
    required this.target,
  });

  /// Counted beads, fractional while the ring settles.
  final double position;

  final int beads;
  final int target;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.40;
    final step = 2 * math.pi / beads;

    // Beads are sized to the ring so they nearly touch, which is what makes a
    // strand of beads read as a strand rather than as dots on a circle.
    final beadRadius = math.min(radius * math.sin(step / 2) * 0.86,
        size.shortestSide * 0.055);

    _paintCord(canvas, centre, radius);

    // The ring turns so the bead just counted sits under the marker at the
    // top. Drawing from the far side forward keeps the near beads on top.
    final rotation = -position * step;

    for (var i = beads - 1; i >= 0; i--) {
      final angle = -math.pi / 2 + i * step + rotation;
      final offset = Offset(
        centre.dx + radius * math.cos(angle),
        centre.dy + radius * math.sin(angle),
      );

      // Which bead of the current round this is.
      final index = ((position.floor() + i) % beads + beads) % beads;
      final isMarker = index == 0;
      final counted = i == 0;

      _paintBead(
        canvas,
        offset,
        isMarker ? beadRadius * 1.38 : beadRadius,
        counted
            ? AppColors.gold
            : isMarker
                ? AppColors.duskDeep
                : AppColors.duskMid,
        glow: counted,
      );
    }

    _paintMarker(canvas, centre, radius, beadRadius);
  }

  /// The cord the beads are strung on.
  void _paintCord(Canvas canvas, Offset centre, double radius) {
    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.dashedBorder.withValues(alpha: 0.55),
    );
  }

  /// One bead, with the rim and highlight that make it read as a sphere
  /// rather than a flat dot.
  void _paintBead(
    Canvas canvas,
    Offset centre,
    double radius,
    Color colour, {
    bool glow = false,
  }) {
    if (glow) {
      canvas.drawCircle(
        centre,
        radius * 1.9,
        Paint()..color = AppColors.gold.withValues(alpha: 0.22),
      );
    }

    // A drop shadow under the bead, so the strand sits above the card.
    canvas.drawCircle(
      centre.translate(0, radius * 0.18),
      radius,
      Paint()
        ..color = const Color(0x22092A28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1.0,
          colors: [
            Color.lerp(colour, Colors.white, 0.42)!,
            colour,
            Color.lerp(colour, Colors.black, 0.22)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: centre, radius: radius)),
    );

    // The specular dot. Small and offset, or the bead looks like a button.
    canvas.drawCircle(
      centre.translate(-radius * 0.32, -radius * 0.36),
      radius * 0.22,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  /// The notch at the top of the loop that says which bead you are on.
  void _paintMarker(
    Canvas canvas,
    Offset centre,
    double radius,
    double beadRadius,
  ) {
    final tip = Offset(centre.dx, centre.dy - radius - beadRadius * 2.1);
    final path = Path()
      ..moveTo(tip.dx, tip.dy + beadRadius * 0.9)
      ..lineTo(tip.dx - beadRadius * 0.55, tip.dy)
      ..lineTo(tip.dx + beadRadius * 0.55, tip.dy)
      ..close();

    canvas.drawPath(path, Paint()..color = AppColors.goldOnIvory);
  }

  @override
  bool shouldRepaint(_BeadRingPainter old) =>
      old.position != position ||
      old.beads != beads ||
      old.target != target;
}
