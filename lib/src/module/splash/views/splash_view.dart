import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:islamic_app/src/core/base/base_view.dart';
import 'package:islamic_app/src/core/constants/app_colors.dart';
import 'package:islamic_app/src/core/constants/app_values.dart';
import 'package:islamic_app/src/core/shared/widgets/asset_image_view.dart';
import 'package:islamic_app/src/module/splash/controllers/splash_controller.dart';

class SplashView extends BaseView<SplashController>{
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