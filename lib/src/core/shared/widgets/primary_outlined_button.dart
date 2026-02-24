import 'package:flutter/material.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';

class PrimaryOutlinedButton extends StatelessWidget {
  const PrimaryOutlinedButton({
    super.key,
    this.onPressed,
    this.title,
    this.child,
    this.width,
    this.height,
    this.textStyle,
  }) : assert(
  title != null || child != null,
  'Either title or child must be provided.',
  );

  final VoidCallback? onPressed;
  final String? title;
  final Widget? child;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(AppValues.radiusRounded),
        child: Stack(
          children: [
            SizedBox(
              width: width ?? AppValues.infinity,
              height: height ?? AppValues.container_50,
              child: OutlinedButton(
                onPressed: onPressed,
                child: (title != null)
                    ? FittedBox(
                  child: Text(
                    title!,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
                    : child,
              ),
            ),
            Positioned(
              top: -20,
              left: -30,
              child: Container(
                height: AppValues.container_60,
                width: AppValues.container_80,
                decoration: BoxDecoration(
                  color: AppColors.brand500.withValues(alpha: 0.15,),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
