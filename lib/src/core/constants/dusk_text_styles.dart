import 'package:flutter/material.dart';

import 'app_values.dart';

/// Al Muttaqee — "Dusk" type system.
///
/// Three families, each with exactly one job:
///
/// * [fontBangla] — Anek Bangla, for every word of interface copy. The app is
///   Bangla-first, so this is the default family, not the exception.
/// * [fontLatin] — Plus Jakarta Sans, for Latin text and for **all large
///   numerals** (countdowns, counters, degrees), where its tabular figures and
///   tighter tracking read better than Anek's.
/// * [fontArabic] — Amiri, for Quran, hadith, dua and surah names.
///
/// All three are bundled under `assets/fonts/` rather than fetched at runtime:
/// a large part of the audience is on poor connections, and Amiri has to be
/// present offline for the Quran reader to render at all.
///
/// Floors that are not negotiable, because the primary audience includes users
/// 45+ with low digital literacy: Bangla body text never below 12.5, nothing
/// below 12 anywhere, text contrast at least 4.5:1.
abstract class DuskText {
  static const String fontBangla = 'AnekBangla';
  static const String fontLatin = 'PlusJakartaSans';
  static const String fontArabic = 'Amiri';

  /// Lining, tabular figures — used wherever a number changes in place so the
  /// digits do not jitter sideways as they tick.
  static const List<FontFeature> tabular = [
    FontFeature.tabularFigures(),
    FontFeature.liningFigures(),
  ];

  // ── Bangla interface text ─────────────────────────────────────────────────

  static TextStyle bangla({
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: fontBangla,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  /// Big prayer name in the home hero.
  static const TextStyle heroPrayerName = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_46,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  /// Screen title inside a hero.
  static const TextStyle heroTitle = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_21,
    fontWeight: FontWeight.w700,
  );

  /// Pushed-screen title inside a hero (a back button shares the row, so this
  /// runs slightly smaller than [heroTitle]).
  static const TextStyle heroTitleBack = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_19,
    fontWeight: FontWeight.w700,
  );

  /// Heading of a section inside a card.
  static const TextStyle cardHeading = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_15_5,
    fontWeight: FontWeight.w700,
  );

  /// Title of a row in a grouped list card.
  static const TextStyle rowTitle = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_15,
    fontWeight: FontWeight.w700,
  );

  /// Label of a settings row — lighter than [rowTitle], which is reserved for
  /// rows that carry data.
  static const TextStyle rowLabel = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_14_5,
    fontWeight: FontWeight.w600,
  );

  /// Value shown at the trailing edge of a data row.
  static const TextStyle rowValue = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_15_5,
    fontWeight: FontWeight.w700,
  );

  /// Trailing value on a settings row.
  static const TextStyle rowTrailing = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_12_5,
    fontWeight: FontWeight.w400,
  );

  /// Secondary line under a row title.
  static const TextStyle rowSubtitle = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_11_5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle rowSubtitleStrong = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_11_5,
    fontWeight: FontWeight.w600,
  );

  /// Long-form body copy — translations, explanations, permission rationale.
  static const TextStyle body = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_14,
    fontWeight: FontWeight.w400,
    height: 1.8,
  );

  static const TextStyle bodyTight = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_14,
    fontWeight: FontWeight.w400,
    height: 1.75,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_12_5,
    fontWeight: FontWeight.w400,
    height: 1.7,
  );

  /// Small section label. Gold on dark grounds, `inkMuted` on light ones.
  static const TextStyle overline = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_11_5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.08 * AppValues.fontSize_11_5,
  );

  /// The wider-tracked overline used in the centred hero blocks.
  static const TextStyle overlineHero = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.12 * AppValues.fontSize_12,
  );

  /// Chip and pill labels.
  static const TextStyle chip = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_11_5,
    fontWeight: FontWeight.w700,
  );

  /// Bottom-nav label.
  static const TextStyle navLabel = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_10_5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_10_5,
    fontWeight: FontWeight.w700,
  );

  /// Label under a tracker circle or a quick-access tile.
  static const TextStyle tileLabel = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_11_5,
    fontWeight: FontWeight.w600,
  );

  /// Label in the আরও grid, which runs one step larger than [tileLabel].
  static const TextStyle gridLabel = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_12,
    fontWeight: FontWeight.w600,
  );

  /// Caption, legend, footnote.
  static const TextStyle caption = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_11_5,
    fontWeight: FontWeight.w400,
  );

  /// Label of a primary button.
  static const TextStyle button = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_16,
    fontWeight: FontWeight.w700,
  );

  /// Label of a secondary button.
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_15,
    fontWeight: FontWeight.w600,
  );

  /// Onboarding page heading.
  static const TextStyle onboardingHeading = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_29,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle onboardingHeadingSmall = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_26,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// The wordmark on the welcome screen.
  static const TextStyle wordmark = TextStyle(
    fontFamily: fontBangla,
    fontSize: AppValues.fontSize_40,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  // ── Numerals (Plus Jakarta Sans) ──────────────────────────────────────────

  /// The big countdown on নামাজ and রমজান.
  static const TextStyle countdown = TextStyle(
    fontFamily: fontLatin,
    fontSize: AppValues.fontSize_52,
    fontWeight: FontWeight.w800,
    height: 1.05,
    letterSpacing: -0.02 * AppValues.fontSize_52,
    fontFeatures: tabular,
  );

  static const TextStyle countdownLarge = TextStyle(
    fontFamily: fontLatin,
    fontSize: AppValues.fontSize_58,
    fontWeight: FontWeight.w800,
    height: 1.05,
    letterSpacing: -0.03 * AppValues.fontSize_58,
    fontFeatures: tabular,
  );

  /// The tasbih counter. The size is computed from the screen width at the
  /// call site, so this one is a function rather than a constant.
  static TextStyle counter(double size) => TextStyle(
        fontFamily: fontLatin,
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: 0.92,
        letterSpacing: -0.04 * size,
        fontFeatures: tabular,
      );

  /// Qibla bearing.
  static const TextStyle degrees = TextStyle(
    fontFamily: fontLatin,
    fontSize: AppValues.fontSize_46,
    fontWeight: FontWeight.w800,
    height: 1.0,
    fontFeatures: tabular,
  );

  /// A headline figure inside a card — zakat payable, plan target.
  static const TextStyle figure = TextStyle(
    fontFamily: fontLatin,
    fontSize: AppValues.fontSize_34,
    fontWeight: FontWeight.w700,
    fontFeatures: tabular,
  );

  static TextStyle latin({
    required double size,
    required FontWeight weight,
    double? height,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: fontLatin,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
        fontFeatures: tabular,
      );

  // ── Arabic (Amiri) ────────────────────────────────────────────────────────

  /// A Quran ayah in the reader.
  static const TextStyle ayah = TextStyle(
    fontFamily: fontArabic,
    fontSize: AppValues.fontSize_25,
    fontWeight: FontWeight.w400,
    height: 2.1,
  );

  /// Arabic in a hadith or dua card.
  static const TextStyle arabicCard = TextStyle(
    fontFamily: fontArabic,
    fontSize: AppValues.fontSize_23,
    fontWeight: FontWeight.w400,
    height: 1.9,
  );

  /// Surah name in the index list.
  static const TextStyle arabicSurahName = TextStyle(
    fontFamily: fontArabic,
    fontSize: AppValues.fontSize_21,
    fontWeight: FontWeight.w400,
  );

  /// The Arabic prayer name under the hero prayer name.
  static const TextStyle arabicHeroName = TextStyle(
    fontFamily: fontArabic,
    fontSize: AppValues.fontSize_20,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// The Arabic wordmark on the welcome screen.
  static const TextStyle arabicWordmark = TextStyle(
    fontFamily: fontArabic,
    fontSize: AppValues.fontSize_30,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle arabic({
    required double size,
    double height = 1.9,
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: fontArabic,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
      );
}
