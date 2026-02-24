import 'package:flutter/material.dart';
import 'package:al_muttaqee/src/core/base/base_widget_mixin.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';

class ProfileMenuCard extends StatelessWidget with BaseWidgetMixin{
  final IconData icon;
  final String title;
  final IconData nextButton;
  final Function() onTap;
  final String type;

  ProfileMenuCard({required this.icon, required this.title, required this.nextButton, required this.onTap, this.type = "Games"});

  @override
  Widget body(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: AppValues.container_56,
        width: double.infinity,
        padding: EdgeInsets.all(AppValues.gap),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppValues.radius_12), color: AppColors.blue900),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotatedBox(
              quarterTurns: type.toLowerCase() == "games" ? 0 : 1,
              child: Icon(icon, color: AppColors.baseWhite),
            ),
            SizedBox(width: AppValues.gap),
            Text(title, style: kFigtree600W14S),
            Spacer(),
            Icon(nextButton, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
