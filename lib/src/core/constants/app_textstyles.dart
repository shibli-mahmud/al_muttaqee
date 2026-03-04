import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:al_muttaqee/l10n/l10n.dart';
import 'app_values.dart';

// Base text style — Figtree for English; Noto Sans Bengali for Bangla
const String _figtreeFamily = 'Figtree';

/// Returns the given style with Bangla font (Noto Sans Bengali) when locale is bn.
TextStyle _resolve(TextStyle base) {
  if (!L10n.isBangla(L10n.selectedLocale)) return base;
  return GoogleFonts.notoSansBengali(
    fontSize: base.fontSize,
    fontWeight: base.fontWeight,
    fontFeatures: base.fontFeatures,
  );
}

// Font weight 200
const _kFigtree200W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree200W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w200,
  fontFeatures: [FontFeature.liningFigures()],
);

// Font weight 300
const _kFigtree300W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree300W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w300,
  fontFeatures: [FontFeature.liningFigures()],
);

// Font weight 400
const _kFigtree400W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree400W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w400,
  fontFeatures: [FontFeature.liningFigures()],
);

// Font weight 500
const _kFigtree500W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree500W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w500,
  fontFeatures: [FontFeature.liningFigures()],
);

// Font weight 600
const _kFigtree600W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree600W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w600,
  fontFeatures: [FontFeature.liningFigures()],
);

// Font weight 700
const _kFigtree700W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree700W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.liningFigures()],
);

// Font weight 800
const _kFigtree800W8S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_8,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W10S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_10,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W12S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_12,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W14S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_14,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W16S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_16,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W18S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_18,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W20S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_20,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W22S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_22,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W24S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_24,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W28S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_28,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W30S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_30,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W32S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_32,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W36S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_36,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W40S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_40,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W50S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_50,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);
const _kFigtree800W60S = TextStyle(
  fontFamily: _figtreeFamily,
  fontSize: AppValues.fontSize_60,
  fontWeight: FontWeight.w800,
  fontFeatures: [FontFeature.liningFigures()],
);

// Public getters — use Bangla font when locale is bn (used by app_themes, widgets)
TextStyle get kFigtree600W14S => _resolve(_kFigtree600W14S);
