import 'package:al_muttaqee/src/module/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/shared/widgets/asset_image_view.dart';

class DashboardView extends BaseView<DashboardController>{
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.container_60),
      height: double.infinity,
      width: double.infinity,
      color: AppColors.baseWhite,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AssetImageView(fileName: 'al_muttaqee_bg.png'
          ),
        ],
      ),
    );
  }


}