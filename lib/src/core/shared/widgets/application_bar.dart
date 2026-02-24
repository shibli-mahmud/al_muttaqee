import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_app/src/core/constants/app_colors.dart';
import 'package:islamic_app/src/core/constants/app_textstyles.dart';
import 'package:islamic_app/src/core/constants/app_values.dart';


class ApplicationBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplicationBar({
    super.key,
    this.leading,
    this.appTitleText,
    this.actions,
    this.bgColor = AppColors.baseBlack,
    this.centerTitle = false,
    this.titleWidget,
    this.iconThemeData,
    this.titleTextStyle = kFigtree600W14S,
    this.systemOverlayStyle,
  });

  final Widget? leading;
  final String? appTitleText;
  final List<Widget>? actions;
  final Color bgColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final TextStyle? titleTextStyle;
  final IconThemeData? iconThemeData;
  final bool centerTitle;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        centerTitle: centerTitle,
        backgroundColor: bgColor,
        leading: leading,
        surfaceTintColor: bgColor,
        elevation: AppValues.elevationLvl1,
        systemOverlayStyle: systemOverlayStyle,
        iconTheme: iconThemeData,
        title: (appTitleText == null)
            ? titleWidget
            : Text(
                appTitleText!,
                style: titleTextStyle,
              ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
