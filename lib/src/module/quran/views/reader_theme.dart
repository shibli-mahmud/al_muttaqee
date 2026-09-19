import 'package:flutter/material.dart';

import 'package:al_muttaqee/src/core/constants/app_colors.dart';

/// The reading surface's colours, day or night.
///
/// The reader is the one screen in the app that inverts. It is also the one
/// screen people use in a dark room at three in the morning, and an ivory page
/// at that hour is physically uncomfortable. Every colour the reader uses
/// comes from here so the two modes cannot drift apart.
class ReaderTheme {
  const ReaderTheme({
    required this.page,
    required this.card,
    required this.cardRaised,
    required this.border,
    required this.hairline,
    required this.primary,
    required this.body,
    required this.muted,
    required this.chip,
    required this.chipInk,
    required this.arabic,
  });

  final Color page;
  final Color card;
  final Color cardRaised;
  final Color border;
  final Color hairline;

  /// Headings and the surah name.
  final Color primary;

  /// The translation.
  final Color body;

  /// References, counts, the reciter's name.
  final Color muted;

  /// The ayah-number chip.
  final Color chip;
  final Color chipInk;

  /// The Quran text itself. The one colour that must never be muted.
  final Color arabic;

  static const ReaderTheme day = ReaderTheme(
    page: AppColors.ivory,
    card: AppColors.surface,
    cardRaised: AppColors.surface,
    border: AppColors.hairline,
    hairline: AppColors.hairline,
    primary: AppColors.ink,
    body: AppColors.inkBody,
    muted: AppColors.inkMuted,
    chip: AppColors.sage,
    chipInk: AppColors.duskMid,
    arabic: AppColors.duskDeep,
  );

  static const ReaderTheme night = ReaderTheme(
    page: AppColors.nightBg,
    card: AppColors.nightCard,
    cardRaised: AppColors.nightCardRaised,
    border: AppColors.nightBorder,
    hairline: AppColors.nightHairline,
    primary: AppColors.nightPrimary,
    body: AppColors.nightBody,
    muted: AppColors.nightMuted,
    chip: AppColors.nightChip,
    chipInk: AppColors.nightChipInk,
    // Not pure white: at night, full-contrast text on a near-black page
    // haloes badly, especially at Amiri's stroke weight.
    arabic: AppColors.nightPrimary,
  );

  static ReaderTheme of(bool night) => night ? ReaderTheme.night : day;

  /// Gold reads the same in both modes, which is why it is the accent.
  Color get accent => AppColors.gold;

  Color get accentInk => AppColors.goldInk;

  /// The tint behind the ayah that is playing.
  Color get playingFill =>
      page == AppColors.nightBg ? AppColors.nightCardRaised : AppColors.goldTintCard;

  Color get playingBorder => page == AppColors.nightBg
      ? AppColors.gold.withValues(alpha: 0.45)
      : AppColors.goldTintBorder;

  Color get playingInk =>
      page == AppColors.nightBg ? AppColors.goldBright : AppColors.goldOnCanvas;
}
