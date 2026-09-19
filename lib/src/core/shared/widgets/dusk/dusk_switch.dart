import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';

/// The Dusk switch: a 46×26 track with a 20px knob inset 3.
///
/// This is a custom widget rather than `Switch.adaptive` because the Material
/// switch cannot be made to match — its track, thumb, elevation and the
/// Material 3 icon inside the thumb are all fixed, and it lands visibly off the
/// rest of the design. The behaviour, including the tap target and the
/// semantics, is the same.
class DuskSwitch extends StatelessWidget {
  const DuskSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;

  /// Null disables the switch, matching Material's convention.
  final ValueChanged<bool>? onChanged;

  final String? semanticLabel;

  static const double _trackWidth = 46;
  static const double _trackHeight = 26;
  static const double _knob = 20;
  static const double _inset = 3;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => onChanged!(!value) : null,
          child: SizedBox(
            height: AppValues.minTapTarget,
            width: _trackWidth,
            child: Center(
              child: AnimatedContainer(
                duration: AppValues.cardPress,
                curve: Curves.easeOut,
                width: _trackWidth,
                height: _trackHeight,
                decoration: BoxDecoration(
                  color: value ? AppColors.gold : AppColors.switchOff,
                  borderRadius: BorderRadius.circular(DuskRadius.chip),
                ),
                child: AnimatedAlign(
                  duration: AppValues.cardPress,
                  curve: Curves.easeOut,
                  alignment:
                      value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _inset),
                    child: Container(
                      width: _knob,
                      height: _knob,
                      decoration: const BoxDecoration(
                        color: AppColors.baseWhite,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
