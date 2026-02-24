import 'package:flutter/material.dart';
import 'package:islamic_app/src/core/constants/app_textstyles.dart';
import 'package:pinput/pinput.dart';

import 'app_colors.dart';
import 'app_values.dart';

final kPrimaryButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(
    AppColors.brand500,
  ),
  elevation: const WidgetStatePropertyAll(
    AppValues.elevationLvl0,
  ),
  overlayColor: WidgetStateProperty.resolveWith(
    (states) {
      return states.contains(WidgetState.pressed)
          ? AppColors.brand500
          : null;
    },
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        AppValues.radiusRounded,
      ),
    ),
  ),
);

final kSecondaryButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(
    AppColors.grey100,
  ),
  elevation: const WidgetStatePropertyAll(
    AppValues.elevationLvl0,
  ),
  overlayColor: WidgetStateProperty.resolveWith(
    (states) {
      return states.contains(WidgetState.pressed) ? AppColors.grey200 : null;
    },
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        AppValues.radiusRounded,
      ),
    ),
  ),
);

final kInactiveButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(
    AppColors.grey400,
  ),
  elevation: const WidgetStatePropertyAll(
    AppValues.elevationLvl0,
  ),
  overlayColor: WidgetStateProperty.resolveWith(
    (states) {
      return states.contains(WidgetState.pressed) ? AppColors.grey300 : null;
    },
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        AppValues.radiusRounded,
      ),
    ),
  ),
);

final kOutlinedPrimaryButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(
    AppColors.baseWhite,
  ),
  elevation: const WidgetStatePropertyAll(
    AppValues.elevationLvl0,
  ),
  overlayColor: WidgetStateProperty.resolveWith(
    (states) {
      return states.contains(WidgetState.pressed) ? AppColors.grey100 : null;
    },
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        AppValues.radiusSmall,
      ),
      side: BorderSide(
        color: AppColors.baseBlack,
      ),
    ),
  ),
);

final kOutlinedSecondaryButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(
    AppColors.baseWhite,
  ),
  elevation: const WidgetStatePropertyAll(
    AppValues.elevationLvl0,
  ),
  overlayColor: WidgetStateProperty.resolveWith(
    (states) {
      return states.contains(WidgetState.pressed) ? AppColors.grey100 : null;
    },
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        AppValues.radiusSmall,
      ),
      side: BorderSide(
        color: AppColors.grey300,
      ),
    ),
  ),
);

final kEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(
    AppValues.radiusSmall,
  ),
  borderSide: BorderSide(
    color: Colors.transparent,
    width: AppValues.dividerThickness_2,
  ),
);

final kDisabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(
    AppValues.radiusSmall,
  ),
  borderSide: BorderSide(
    color: Colors.transparent,
    width: AppValues.dividerThickness_2,
  ),
);

final kErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(
    AppValues.radiusSmall,
  ),
  borderSide: BorderSide(
    color: AppColors.red500,
    width: AppValues.dividerThickness_2,
  ),
);

final kFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(
    AppValues.radiusSmall,
  ),
  borderSide: BorderSide(
    color: Colors.transparent,
    width: AppValues.dividerThickness_2,
  ),
);

final defaultPinTheme = PinTheme(
  width: AppValues.container_60,
  height: AppValues.container_60,
  textStyle: kFigtree600W14S.copyWith(color: AppColors.baseWhite),
  decoration: BoxDecoration(color: AppColors.brand500,
    border: BoxBorder.all(
      color: AppColors.brand500.withAlpha(150),width: 0.5,
    ),
    borderRadius: BorderRadius.circular(
      AppValues.radius,
    ),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(
    color: AppColors.brand500.withAlpha(150),width: 0.5,
  ),
);

final searchBarShape = WidgetStatePropertyAll<OutlinedBorder>(
  RoundedRectangleBorder(
    side: BorderSide(
      color: AppColors.grey400,
    ),
    borderRadius: BorderRadius.circular(
      AppValues.radiusSmall,
    ), // Customize the border radius
  ),
);

// final dateBorder = InputDecoration(
//   hintStyle: kTextSMNormal.copyWith(
//     color: AppColors.grey400,
//   ),
//   contentPadding: EdgeInsets.symmetric(
//     horizontal: AppValues.gap,
//   ),
//   suffixIcon: Icon(
//     Bootstrap.calendar_event,
//     color: AppColors.grey900,
//     size: AppValues.icon_16,
//   ),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(
//       AppValues.radiusSmall,
//     ),
//     borderSide: BorderSide(
//       color: AppColors.grey200,
//     ),
//   ),
// );

final cardBorder = BoxDecoration(
  color: AppColors.baseWhite,
  borderRadius: BorderRadius.circular(
    AppValues.radiusSmall,
  ),
  border: Border.all(
    color: AppColors.grey200,
    width: AppValues.dividerThickness_2,
  ),
);
