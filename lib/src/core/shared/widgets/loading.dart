import 'package:flutter/material.dart';
import 'package:islamic_app/src/core/constants/app_colors.dart';
import 'package:islamic_app/src/core/constants/app_values.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.green500.withOpacity(
            0.55,
          ),
          borderRadius: BorderRadius.circular(
            AppValues.radiusSmall,
          ),
        ),
        padding: const EdgeInsets.all(
          AppValues.gap,
        ),
        child: const CircularProgressIndicator(
          color: AppColors.brand500,
        ),
      ),
    );
  }
}
