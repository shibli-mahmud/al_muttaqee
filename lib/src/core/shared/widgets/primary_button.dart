import 'package:flutter/material.dart';
import 'package:islamic_app/src/core/constants/app_colors.dart';
import 'package:islamic_app/src/core/constants/app_textstyles.dart';
import 'package:islamic_app/src/core/constants/app_themes.dart';


class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.onPressed,
    this.title,
    this.titleColor=AppColors.baseWhite,
    this.child,
    this.width,
    this.height,
    this.bgColor,
  })  : assert(
          title != null || child != null,
          'Either title or child must be provided.',
        ),
        super(key: key);

  final VoidCallback? onPressed;
  final String? title;
  final Color? titleColor;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
    
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: (onPressed == null) ? kInactiveButtonStyle : bgColor!=null?kPrimaryButtonStyle.copyWith(backgroundColor: WidgetStatePropertyAll(bgColor)):kPrimaryButtonStyle,
        child: (title != null)
            ? Text(
                title!,
                style: kFigtree600W14S.copyWith(
                  color: titleColor
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : child,
      ),
    );
  }
}
