import 'package:flutter/material.dart';

/// Al Muttaqee — "Dusk" palette.
///
/// Drop-in replacement for `lib/src/core/constants/app_colors.dart`.
/// Call-site style is unchanged (`AppColors.<name>`), so existing screens keep
/// compiling while they are migrated one at a time.
///
/// Contrast is part of the palette, not an afterthought: the primary audience
/// includes users 45+ with low digital literacy, so every text token below is
/// >= 4.5:1 on its intended ground. Where a role needed a lighter value for
/// fills, a separate darker token exists for the same role used as *text*
/// (e.g. [gold] for fills vs [goldOnIvory] / [goldOnCanvas] for type).
class AppColors {
  AppColors._();

  // ── Base ──────────────────────────────────────────────────────────────────
  static const Color baseBlack = Color(0xFF000000);
  static const Color baseWhite = Color(0xFFFFFFFF);
  static const Color baseTransparent = Color(0x00000000);

  /// App page background.
  static const Color ivory = Color(0xFFFBF8F3);

  /// Card / raised surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Design-board canvas only — NOT an in-app colour.
  static const Color canvas = Color(0xFFEFE9DE);

  // ── Deep teal (brand dark) ────────────────────────────────────────────────
  /// Hero gradient start, bottom nav, primary dark surface.
  static const Color duskDeep = Color(0xFF06312F);

  /// Hero gradient end, icon ink on [sage], "prayed" tracker fill.
  static const Color duskMid = Color(0xFF0B4A45);

  /// Third gradient stop (home hero only).
  static const Color duskLight = Color(0xFF14655A);

  // ── Gold (the accent) ─────────────────────────────────────────────────────
  /// The accent. Primary action, live value, active tab, current prayer.
  /// One gold element per screen — the thing the user came for.
  static const Color gold = Color(0xFFC9A227);

  /// Pressed state for gold fills.
  static const Color goldPressed = Color(0xFFB08D1E);

  /// Text and icons ON [gold].
  static const Color goldInk = Color(0xFF241A00);

  /// Secondary text ON [gold].
  static const Color goldInkSoft = Color(0xFF3A2B00);

  /// Gold as TEXT on [ivory] / [surface]. ~4.6:1. Never use [gold] for
  /// paragraph-size type on a light ground — it measures 2.5:1.
  static const Color goldOnIvory = Color(0xFF8A6A0F);

  /// Gold as TEXT on the darker [canvas] ground.
  static const Color goldOnCanvas = Color(0xFF7A5C00);

  /// Gold as text/icons on [duskDeep] / [duskMid].
  static const Color goldBright = Color(0xFFE9CE73);

  /// Chip / streak-pill fill on light grounds.
  static const Color goldTint = Color(0xFFFFF4D6);

  /// Selected-card fill on light grounds.
  static const Color goldTintCard = Color(0xFFFFF9E8);

  /// 1px border for gold-tinted cards.
  static const Color goldTintBorder = Color(0xFFF0DFA8);

  /// Deep ink for text on [goldTint] / [goldTintCard].
  static const Color goldTintInk = Color(0xFF5C4400);
  static const Color goldTintInkSoft = Color(0xFF6B5100);

  // ── Sage (resting tint) ───────────────────────────────────────────────────
  /// Icon chips, secondary date card, informational panels.
  static const Color sage = Color(0xFFDCE8E2);

  /// Body text on [sage].
  static const Color sageInk = Color(0xFF2F4B47);

  /// Label text on [sage].
  static const Color sageLabel = Color(0xFF456660);

  // ── Ink (text on light) ───────────────────────────────────────────────────
  static const Color ink = Color(0xFF12211F);
  static const Color inkBody = Color(0xFF283634);
  static const Color inkSecondary = Color(0xFF3D4A47);

  /// Lightest permitted colour for TEXT on a light ground (~5.9:1 on white).
  /// Do not introduce anything lighter for type.
  static const Color inkMuted = Color(0xFF5E6B68);

  // ── On-dark text ──────────────────────────────────────────────────────────
  static const Color onDeepPrimary = Color(0xFFF5EFE1);
  static const Color onDeepMuted = Color(0xFF9EC4BC);

  /// Cardinal letters / tertiary marks on [duskDeep].
  static const Color onDeepFaint = Color(0xFFA8C2BC);

  // ── Structural ────────────────────────────────────────────────────────────
  /// 2px dashed outline for the "not yet" tracker state.
  static const Color dashedBorder = Color(0xFFB6C4C0);

  /// Hairline on [ivory].
  static const Color hairline = Color(0xFFE7E0D2);

  /// Neutral row fill inside cards (jamaat cells, stat tiles).
  static const Color neutralFill = Color(0xFFF5F2EA);

  /// Muted state-chip fill ("নীরব" / "বন্ধ").
  static const Color mutedChip = Color(0xFFEFEAE0);

  /// Switch track, off.
  static const Color switchOff = Color(0xFFD8D2C4);

  /// Bottom-sheet grab handle.
  static const Color grabHandle = Color(0xFFD8D2C4);

  // ── Tracker / heatmap ─────────────────────────────────────────────────────
  static const Color trackEmpty = Color(0xFFEDE7DA);
  static const Color trackPartial = Color(0xFFA8C9C2);
  static const Color trackPartialStrong = Color(0xFF5E9B90);
  static const Color trackFull = duskMid;

  // ── Semantic ──────────────────────────────────────────────────────────────
  /// Negative amounts (zakat deductions). Never used as a fill.
  static const Color danger = Color(0xFFA33B12);

  // ── Per-prayer icon-chip tints ────────────────────────────────────────────
  static const Color fajrChip = sage;
  static const Color fajrChipInk = duskMid;
  static const Color dhuhrChip = sage;
  static const Color dhuhrChipInk = duskMid;
  static const Color asrChip = gold;
  static const Color asrChipInk = goldInk;
  static const Color maghribChip = Color(0xFFFFF0DB);
  static const Color maghribChipInk = Color(0xFF8A4A0F);
  static const Color ishaChip = Color(0xFFE4E4F2);
  static const Color ishaChipInk = Color(0xFF3B3A6B);
  static const Color sunriseChip = Color(0xFFF1EDE4);
  static const Color sunriseChipInk = inkMuted;

  // ── Ramadan (amber season) ────────────────────────────────────────────────
  static const Color ramadanDeep = Color(0xFF3D1608);
  static const Color ramadanMid = Color(0xFF7A3B12);
  static const Color ramadanLight = Color(0xFFC77A2E);
  static const Color ramadanAccent = Color(0xFFFFD48A);
  static const Color ramadanOnPrimary = Color(0xFFFFF3DC);
  static const Color ramadanOnMuted = Color(0xFFF0C79A);
  static const Color ramadanAccentInk = Color(0xFF3D1608);
  static const Color ramadanAccentInkSoft = Color(0xFF4A2405);
  static const Color ramadanAccentLabel = Color(0xFF6B3708);
  static const Color ramadanLabelOnLight = Color(0xFF8A4A0F);

  /// Missed fast — dark enough to carry white numerals (~5.5:1).
  static const Color ramadanMissed = Color(0xFF6E6A63);

  // ── Night reading mode ────────────────────────────────────────────────────
  static const Color nightBg = Color(0xFF0A1614);
  static const Color nightCard = Color(0xFF121E1C);
  static const Color nightCardRaised = Color(0xFF152220);
  static const Color nightBorder = Color(0xFF223330);
  static const Color nightHairline = Color(0xFF1B2A28);
  static const Color nightPrimary = Color(0xFFF0EDE4);
  static const Color nightBody = Color(0xFFD6D2C6);
  static const Color nightMuted = Color(0xFF8FA6A1);
  static const Color nightChip = Color(0xFF1F302D);
  static const Color nightChipInk = onDeepMuted;


  // ── Legacy aliases ────────────────────────────────────────────────────────
  // The Dusk swap is one commit: screens that have not been rebuilt yet keep
  // their old `AppColors.<name>` call sites but resolve to Dusk values, so the
  // whole app shifts palette at once instead of going half-and-half. Delete an
  // alias as its last call site is rewritten; do not add new ones.

  static const Color baseBackground = ivory;

  static const Color brand100 = Color(0xFFEFF5F2);
  static const Color brand200 = sage;
  static const Color brand300 = Color(0xFFB9D2CB);
  static const Color brand400 = Color(0xFF6E9C94);
  static const Color brand500 = duskMid;
  static const Color brand600 = Color(0xFF083E3A);
  static const Color brand700 = duskDeep;
  static const Color brand800 = Color(0xFF04211F);
  static const Color brand900 = Color(0xFF021413);

  static const Color grey100 = ivory;
  static const Color grey200 = Color(0xFFE7E0D2);
  static const Color grey300 = Color(0xFFD8D2C4);
  static const Color grey400 = dashedBorder;
  static const Color grey500 = Color(0xFF8A9793);
  static const Color grey600 = inkMuted;
  static const Color grey700 = inkSecondary;
  static const Color grey800 = inkBody;
  static const Color grey900 = ink;

  static const Color red100 = Color(0xFFFBEDE7);
  static const Color red300 = Color(0xFFE0A48B);
  static const Color red400 = Color(0xFFC96A44);
  static const Color red500 = danger;
  static const Color red600 = Color(0xFF8E3310);
  static const Color red700 = Color(0xFF7A2C0E);

  static const Color green100 = Color(0xFFEAF2EE);
  static const Color green400 = trackPartialStrong;
  static const Color green500 = duskMid;
  static const Color green600 = Color(0xFF083E3A);
  static const Color green700 = duskDeep;

  static const Color orange100 = maghribChip;
  static const Color orange400 = ramadanAccent;
  static const Color orange500 = ramadanLight;
  static const Color orange600 = ramadanMid;
  static const Color orange700 = maghribChipInk;

  static const Color blue900 = ishaChipInk;

  // ── Elevation ─────────────────────────────────────────────────────────────
  /// One shadow per element. Never stack.
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: Color(0x0D092A28), blurRadius: 12, offset: Offset(0, 3)),
  ];

  static const List<BoxShadow> shadowCardRaised = [
    BoxShadow(color: Color(0x14092A28), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> shadowNav = [
    BoxShadow(color: Color(0x4D06312F), blurRadius: 26, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> shadowGold = [
    BoxShadow(color: Color(0x59C9A227), blurRadius: 26, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> shadowSheet = [
    BoxShadow(color: Color(0x29092A28), blurRadius: 34, offset: Offset(0, -12)),
  ];

  static const List<BoxShadow> shadowCounter = [
    BoxShadow(color: Color(0x1A092A28), blurRadius: 34, offset: Offset(0, 12)),
  ];
}

/// Which prayer window the UI is currently themed for.
enum DuskWindow { fajr, day, maghrib, isha }

/// The time-of-day hero theme.
///
/// The hero gradient shifts across the day — deep blue before sunrise, teal
/// through the day, amber at sunset, midnight at night — while the gold accent
/// and the on-hero text colours stay put per window, so contrast never drifts.
/// Cross-fade over 400ms `Curves.easeInOut` when the window turns over.
class DuskHeroTheme {
  const DuskHeroTheme({
    required this.window,
    required this.gradient,
    required this.onPrimary,
    required this.onMuted,
    required this.accent,
    required this.accentInk,
    required this.patternInk,
    required this.patternOpacity,
  });

  final DuskWindow window;
  final List<Color> gradient;

  /// Primary text on the hero.
  final Color onPrimary;

  /// Secondary text on the hero.
  final Color onMuted;

  /// Accent fill on the hero (current-prayer cell, countdown pill border).
  final Color accent;

  /// Text/icons on [accent].
  final Color accentInk;

  /// Stroke colour for the tiled khatim star.
  final Color patternInk;
  final double patternOpacity;

  static const DuskHeroTheme fajr = DuskHeroTheme(
    window: DuskWindow.fajr,
    gradient: [Color(0xFF101B4A), Color(0xFF2B3E7A)],
    onPrimary: AppColors.onDeepPrimary,
    onMuted: Color(0xFFA8B4D8),
    accent: AppColors.gold,
    accentInk: AppColors.goldInk,
    patternInk: AppColors.onDeepPrimary,
    patternOpacity: 0.12,
  );

  static const DuskHeroTheme day = DuskHeroTheme(
    window: DuskWindow.day,
    gradient: [AppColors.duskDeep, AppColors.duskMid, AppColors.duskLight],
    onPrimary: AppColors.onDeepPrimary,
    onMuted: AppColors.onDeepMuted,
    accent: AppColors.gold,
    accentInk: AppColors.goldInk,
    patternInk: AppColors.onDeepPrimary,
    patternOpacity: 0.13,
  );

  static const DuskHeroTheme maghrib = DuskHeroTheme(
    window: DuskWindow.maghrib,
    gradient: [
      AppColors.ramadanDeep,
      AppColors.ramadanMid,
      AppColors.ramadanLight,
    ],
    onPrimary: AppColors.ramadanOnPrimary,
    onMuted: AppColors.ramadanOnMuted,
    accent: AppColors.ramadanAccent,
    accentInk: AppColors.ramadanAccentInk,
    patternInk: AppColors.ramadanOnPrimary,
    patternOpacity: 0.14,
  );

  static const DuskHeroTheme isha = DuskHeroTheme(
    window: DuskWindow.isha,
    gradient: [Color(0xFF0A1220), Color(0xFF1E2A47)],
    onPrimary: AppColors.onDeepPrimary,
    onMuted: Color(0xFF9AA6C0),
    accent: AppColors.gold,
    accentInk: AppColors.goldInk,
    patternInk: AppColors.onDeepPrimary,
    patternOpacity: 0.12,
  );

  /// Pick the hero theme for the prayer window that is currently running.
  /// Drive this from `PrayerTimesController.dayTimes.current`.
  static DuskHeroTheme forWindow(DuskWindow window) => switch (window) {
        DuskWindow.fajr => fajr,
        DuskWindow.day => day,
        DuskWindow.maghrib => maghrib,
        DuskWindow.isha => isha,
      };

  /// The same theme with a stronger or weaker khatim texture.
  ///
  /// Onboarding and Ramadan run the pattern at 0.14–0.16 rather than the usual
  /// 0.12–0.13: those heroes are taller and carry less text, so the texture has
  /// to work harder to stop the gradient reading as a flat block.
  DuskHeroTheme copyWithPattern(double opacity) => DuskHeroTheme(
        window: window,
        gradient: gradient,
        onPrimary: onPrimary,
        onMuted: onMuted,
        accent: accent,
        accentInk: accentInk,
        patternInk: patternInk,
        patternOpacity: opacity,
      );

  LinearGradient get decoration => LinearGradient(
        begin: const AlignmentDirectional(-0.35, -1),
        end: const AlignmentDirectional(0.35, 1),
        colors: gradient,
      );
}

/// Corner radii. Nothing in this design is square except heatmap cells.
abstract class DuskRadius {
  static const double sheet = 32;
  static const double hero = 28;
  static const double heroHome = 30;
  static const double nav = 26;
  static const double card = 24;
  static const double cardTight = 22;
  static const double cardSmall = 20;
  static const double counter = 32;
  static const double inner = 18;
  static const double navPill = 19;
  static const double iconChip = 12;
  static const double iconChipLarge = 14;
  static const double gridCell = 5;
  static const double chip = 999;
}
