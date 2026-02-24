import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:islamic_app/src/core/base/base_widget_mixin.dart';
import 'package:islamic_app/src/core/constants/app_colors.dart';
import 'package:islamic_app/src/core/constants/app_values.dart';

class TextWithIcon extends StatelessWidget with BaseWidgetMixin {
  TextWithIcon({
    required this.icon,
    required this.title,
    this.textStyle,
    this.iconSize,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final TextStyle? textStyle;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget body(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColors.grey400,
          size: iconSize ?? AppValues.icon_16,
        ),
        SizedBox(width: AppValues.gapXSmall),
        Expanded(
          child: Text(
            title,
            softWrap: true,
            style: textStyle ??
                context.textTheme.bodyMedium!.copyWith(
                  color: AppColors.grey200,
                ),
          ),
        ),
      ],
    );
  }
}

