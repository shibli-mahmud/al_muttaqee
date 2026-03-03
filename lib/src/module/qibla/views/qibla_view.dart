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
              'Preparing Qibla compass...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey800,
                  ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return _buildCompassContent(context);
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
              'Location access required',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.brand800,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppValues.space_8),
            Text(
              'Please enable location services and grant permission so we can calculate the direction of Qibla from your current position.',
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

  Widget _buildCompassContent(BuildContext context) {
    final double qibla = controller.qiblaDirection.value;
    final double heading = controller.heading.value;
    final double angle = (qibla - heading) * math.pi / 180;
    final double tilt = controller.tilt.value;

    final bool isLevel = tilt < 10;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Qibla Direction',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppValues.gapLarge),
        SizedBox(
          width: AppValues.container_320,
          height: AppValues.container_320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: AppValues.container_280,
                height: AppValues.container_280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.baseWhite,
                  border: Border.all(
                    color: AppColors.brand500,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey300.withOpacity(0.6),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 24,
                child: Text(
                  'N',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey800,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Positioned(
                bottom: 24,
                child: Text(
                  'S',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Positioned(
                left: 24,
                child: Text(
                  'W',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Positioned(
                right: 24,
                child: Text(
                  'E',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Transform.rotate(
                angle: angle,
                child: Icon(
                  PhosphorIconsFill.navigationArrow,
                  size: AppValues.icon_96,
                  color: AppColors.brand700,
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brand500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppValues.gapLarge),
        Text(
          'Point the arrow towards the top of your device to face Qibla.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey800,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppValues.gap),
        Text(
          'Qibla: ${qibla.toStringAsFixed(0)}°  |  Heading: ${heading.toStringAsFixed(0)}°',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey700,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppValues.gapLarge),
        _buildGravityIndicator(context, tilt, isLevel),
      ],
    );
  }

  Widget _buildGravityIndicator(
    BuildContext context,
    double tilt,
    bool isLevel,
  ) {
    final double level = (1 - (tilt / 90)).clamp(0.0, 1.0);

    final String label = isLevel
        ? 'Device is level'
        : 'Tilt: ${tilt.toStringAsFixed(0)}° — try to hold the device flat.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Gravity level',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppValues.space_8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppValues.radiusRounded),
          child: LinearProgressIndicator(
            value: level,
            minHeight: 8,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isLevel ? AppColors.green600 : AppColors.orange500,
            ),
          ),
        ),
        const SizedBox(height: AppValues.space_4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey800,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}