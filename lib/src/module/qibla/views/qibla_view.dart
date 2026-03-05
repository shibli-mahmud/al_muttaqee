import 'dart:math' as math;

import 'package:al_muttaqee/src/module/qibla/controllers/qibla_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class QiblaView extends BaseView<QiblaController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.baseBackground,
      padding: const EdgeInsets.all(AppValues.gapLarge),
      child: Obx(() {
        if (!controller.isLocationServiceEnabled.value ||
            !controller.hasLocationPermission.value) {
          return _buildPermissionInfo(context);
        }

        if (!controller.isReady.value) {
          // BaseView already shows a loading overlay; keep the content simple.
          return Center(
            child: Text(
              appLocalization.preparingQiblaCompass,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey800,
                  ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _buildCompassContent(context),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildPermissionInfo(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppValues.gapLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.mapPin,
              size: AppValues.icon_64,
              color: AppColors.brand600,
            ),
            const SizedBox(height: AppValues.gap),
            Text(
              appLocalization.locationAccessRequired,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.brand800,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppValues.space_8),
            Text(
              appLocalization.locationAccessMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey800,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.gap,
        vertical: AppValues.space_8,
      ),
      margin: const EdgeInsets.symmetric(horizontal: AppValues.gap),
      decoration: BoxDecoration(
        color: AppColors.orange100,
        borderRadius: BorderRadius.circular(AppValues.radiusSmall),
        border: Border.all(color: AppColors.orange400, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                PhosphorIconsFill.warning,
                color: AppColors.orange600,
                size: AppValues.icon_22,
              ),
              const SizedBox(width: AppValues.space_8),
              Expanded(
                child: Text(
                  appLocalization.compassCalibrationMessage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.gap),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 64,
                  child: _FigureEightGuide(),
                ),
                const SizedBox(height: AppValues.space_4),
                Text(
                  appLocalization.moveDeviceLikeThis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.orange700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          appLocalization.qiblaDirection,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppValues.gap),
        Obx(() {
          if (!controller.compassNeedsCalibration.value) return const SizedBox.shrink();
          return _buildCalibrationBanner(context);
        }),
        const SizedBox(height: AppValues.gapLarge),
        Obx(() {
          final double qibla = controller.qiblaDirection.value;
          final double heading = controller.heading.value;
          final double angle = (qibla - heading) * math.pi / 180;
          return SizedBox(
            width: AppValues.container_320,
            height: AppValues.container_320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildCompassBezel(context),
                _buildCompassFace(context),
                _buildCardinalLabels(context),
                Transform.rotate(
                  angle: angle,
                  child: Icon(
                    PhosphorIconsFill.navigationArrow,
                    size: AppValues.icon_96,
                    color: AppColors.brand700,
                  ),
                ),
                _buildCenterBubbleLevel(context),
              ],
            ),
          );
        }),
        const SizedBox(height: AppValues.gapLarge),
        Text(
          appLocalization.qiblaDirectionHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey800,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppValues.gap),
        Obx(() {
          final double qibla = controller.qiblaDirection.value;
          final double heading = controller.heading.value;
          return Text(
            appLocalization.qiblaHeadingFormat(qibla, heading),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey700,
                ),
            textAlign: TextAlign.center,
          );
        }),
        const SizedBox(height: AppValues.gapLarge),
        Obx(() => _buildGravityIndicator(
              context,
              controller.tilt.value,
              controller.tilt.value < 10,
            )),
        const SizedBox(height: AppValues.gapLarge),
      ],
    );
  }

  /// Outer metallic bezel and shadow for a realistic compass look.
  Widget _buildCompassBezel(BuildContext context) {
    const double size = 280;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey800.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.baseBlack.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            Color(0xFF5C4A3A),
            Color(0xFF4A3C2F),
            Color(0xFF3D3228),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: size - 16,
          height: size - 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF6B5A4A),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.baseBlack.withOpacity(0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Inner compass face with degree ticks and subtle compass rose.
  Widget _buildCompassFace(BuildContext context) {
    const double size = 248;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF5F0E8),
        border: Border.all(
          color: Color(0xFFD4C4B0),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.baseBlack.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _CompassTicksPainter(),
        size: const Size(size, size),
      ),
    );
  }

  /// Cardinal direction labels (N, S, E, W). Stack is 320px; face is 248px centered, so face edge at 36px.
  Widget _buildCardinalLabels(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 22,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'N',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.brand700,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ),
        Positioned(
          bottom: 22,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'S',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        Positioned(
          left: 22,
          top: 0,
          bottom: 0,
          child: Center(
            child: Text(
              'W',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        Positioned(
          right: 22,
          top: 0,
          bottom: 0,
          child: Center(
            child: Text(
              'E',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  /// Center spirit level: circle with a bubble that moves with tilt.
  Widget _buildCenterBubbleLevel(BuildContext context) {
    const double levelCircleSize = 56;
    const double bubbleSize = 18;
    const double maxBubbleOffset = (levelCircleSize / 2) - (bubbleSize / 2) - 4;

    return Obx(() {
      final double tx = controller.tiltX.value;
      final double ty = controller.tiltY.value;
      final double tilt = controller.tilt.value;
      final bool isLevel = tilt < 10;
      final double dx = tx * maxBubbleOffset;
      final double dy = ty * maxBubbleOffset;

      final List<Color> bubbleColors = isLevel
          ? [
              AppColors.green100,
              AppColors.green400,
              AppColors.green700,
            ]
          : [
              AppColors.red100,
              AppColors.red400,
              AppColors.red700,
            ];

      return Container(
        width: levelCircleSize,
        height: levelCircleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey200.withOpacity(0.85),
          border: Border.all(
            color: AppColors.grey500,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.baseBlack.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: AppColors.baseWhite.withOpacity(0.6),
              blurRadius: 0,
              offset: const Offset(-1, -1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Container(
                    width: bubbleSize,
                    height: bubbleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: const Alignment(-0.3, -0.3),
                        radius: 0.9,
                        colors: bubbleColors,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.baseBlack.withOpacity(0.25),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGravityIndicator(
    BuildContext context,
    double tilt,
    bool isLevel,
  ) {
    final String label = isLevel
        ? appLocalization.deviceLevelMessage
        : appLocalization.tiltMessage(tilt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          appLocalization.levelIndicator,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppValues.space_8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.gap,
            vertical: AppValues.space_6,
          ),
          decoration: BoxDecoration(
            color: isLevel
                ? AppColors.green100
                : AppColors.orange100,
            borderRadius: BorderRadius.circular(AppValues.radiusSmall),
            border: Border.all(
              color: isLevel ? AppColors.green400 : AppColors.orange400,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLevel ? AppColors.green600 : AppColors.orange500,
                ),
              ),
              // const SizedBox(width: AppValues.gap_4),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey800,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows a figure-8 path with an animated dot so the user knows how to move the device to calibrate the compass.
class _FigureEightGuide extends StatefulWidget {
  @override
  State<_FigureEightGuide> createState() => _FigureEightGuideState();
}

class _FigureEightGuideState extends State<_FigureEightGuide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _FigureEightPainter(progress: _controller.value),
          size: const Size(120, 64),
        );
      },
    );
  }
}

class _FigureEightPainter extends CustomPainter {
  _FigureEightPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const double centerX = 60;
    const double centerY = 32;
    const double scaleX = 50;
    const double scaleY = 24;

    // Draw figure-8 path (lemniscate: x = sin(t), y = sin(2t)/2)
    final path = Path();
    const int segments = 80;
    for (int i = 0; i <= segments; i++) {
      final t = (i / segments) * 2 * math.pi;
      final x = centerX + scaleX * math.sin(t);
      final y = centerY + scaleY * math.sin(2 * t);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final pathPaint = Paint()
      ..color = AppColors.orange600.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, pathPaint);

    // Animated dot showing motion along the 8
    final t = progress * 2 * math.pi;
    final dotX = centerX + scaleX * math.sin(t);
    final dotY = centerY + scaleY * math.sin(2 * t);

    canvas.drawCircle(
      Offset(dotX, dotY),
      6,
      Paint()..color = AppColors.orange700,
    );
    canvas.drawCircle(
      Offset(dotX, dotY),
      4,
      Paint()..color = AppColors.baseWhite,
    );
  }

  @override
  bool shouldRepaint(covariant _FigureEightPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Paints degree ticks and subtle markings on the compass face for a realistic look.
class _CompassTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 4;

    // Minor ticks every 6°, major every 30°
    for (int i = 0; i < 60; i++) {
      final double angle = (i * 6 - 90) * math.pi / 180; // 0° at top (N)
      final bool isMajor = i % 5 == 0;
      final double innerR = radius - (isMajor ? 12 : 6);
      final double outerR = radius;

      final double x1 = centerX + innerR * math.cos(angle);
      final double y1 = centerY + innerR * math.sin(angle);
      final double x2 = centerX + outerR * math.cos(angle);
      final double y2 = centerY + outerR * math.sin(angle);

      final paint = Paint()
        ..color = isMajor
            ? AppColors.grey700.withOpacity(0.5)
            : AppColors.grey500.withOpacity(0.3)
        ..strokeWidth = isMajor ? 2 : 1
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Inner ring (optional subtle circle)
    final ringPaint = Paint()
      ..color = AppColors.grey400.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(centerX, centerY), radius - 20, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}