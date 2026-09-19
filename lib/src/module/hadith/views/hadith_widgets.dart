import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/hadith/controllers/hadith_controller.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';

/// A hadith as it reads on the chapter, search and bookmark screens.
///
/// Arabic first, right-aligned in Amiri, then the Bangla. The reference chip
/// and the grading sit in the header where they can be scanned down a list;
/// the grading matters — a reader needs to know a যঈফ narration is যঈফ before
/// they act on it, not after.
class HadithCard extends StatelessWidget {
  const HadithCard({
    super.key,
    required this.hadith,
    required this.controller,
    this.bookName,
    this.chapterName,
    this.highlight = '',
  });

  final Hadith hadith;
  final HadithController controller;
  final String? bookName;
  final String? chapterName;

  /// Search terms to mark inside the Bangla text.
  final String highlight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DuskCard(
      radius: DuskRadius.cardTight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(l10n),
          if (hadith.arabic.isNotEmpty) ...[
            const SizedBox(height: AppValues.space_12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                hadith.arabic,
                textAlign: TextAlign.right,
                style: DuskText.arabicCard.copyWith(color: AppColors.duskDeep),
              ),
            ),
          ],
          if (hadith.bengali.isNotEmpty) ...[
            const SizedBox(height: AppValues.space_12),
            _HighlightedText(
              text: hadith.bengali,
              query: highlight,
              style: DuskText.bodyTight.copyWith(color: AppColors.inkBody),
            ),
          ],
          const SizedBox(height: AppValues.space_12),
          _footer(l10n),
        ],
      ),
    );
  }

  Widget _header(AppLocalizations l10n) {
    return Row(
      children: [
        DuskPill(
          label: formatNumberWithLocale(hadith.number),
          background: AppColors.goldTint,
          foreground: AppColors.goldOnCanvas,
        ),
        if (hadith.grade.isNotEmpty) ...[
          const SizedBox(width: AppValues.gap_6),
          _GradeChip(grade: hadith.grade),
        ],
        const Spacer(),
        Obx(
          () => _IconAction(
            icon: controller.isBookmarked(hadith)
                ? PhosphorIconsFill.bookmarkSimple
                : PhosphorIconsRegular.bookmarkSimple,
            color: controller.isBookmarked(hadith)
                ? AppColors.goldOnIvory
                : AppColors.inkMuted,
            tooltip: l10n.bookmark,
            onTap: () => controller.toggleBookmark(hadith),
          ),
        ),
        _IconAction(
          icon: PhosphorIconsRegular.copy,
          color: AppColors.inkMuted,
          tooltip: l10n.copyHadith,
          onTap: () => _copy(l10n),
        ),
      ],
    );
  }

  Widget _footer(AppLocalizations l10n) {
    final reference = [
      if (bookName != null && bookName!.isNotEmpty) bookName!,
      if (chapterName != null && chapterName!.isNotEmpty) chapterName!,
      formatNumberWithLocale(hadith.number),
    ].join(' · ');

    return Text(
      reference,
      style: DuskText.rowSubtitleStrong.copyWith(color: AppColors.inkMuted),
    );
  }

  Future<void> _copy(AppLocalizations l10n) async {
    final reference = [
      if (bookName != null && bookName!.isNotEmpty) bookName!,
      formatNumberWithLocale(hadith.number),
    ].join(' · ');

    await Clipboard.setData(
      ClipboardData(
        text: [
          if (hadith.arabic.isNotEmpty) hadith.arabic,
          if (hadith.bengali.isNotEmpty) hadith.bengali,
          reference,
        ].join('\n\n'),
      ),
    );
    Get.snackbar(
      '',
      l10n.copiedToClipboard,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        l10n.copiedToClipboard,
        style: DuskText.rowLabel.copyWith(color: AppColors.onDeepPrimary),
      ),
      backgroundColor: AppColors.duskDeep,
      margin: const EdgeInsets.all(AppValues.cardPadding),
      borderRadius: DuskRadius.inner,
      duration: const Duration(seconds: 2),
    );
  }
}

/// The authenticity badge.
///
/// Colour carries the meaning here, so it is not decoration: সহিহ and হাসান
/// rest in sage, anything weaker takes the danger tint. A reader scanning a
/// sunan chapter should be able to see at a glance which narrations are weak.
class _GradeChip extends StatelessWidget {
  const _GradeChip({required this.grade});

  final String grade;

  static const Set<String> _sound = {'সহিহ', 'হাসান', 'হাসান সহিহ'};

  @override
  Widget build(BuildContext context) {
    final sound = _sound.contains(grade);
    return DuskPill(
      label: grade,
      background: sound ? AppColors.sage : const Color(0xFFF7E7E0),
      foreground: sound ? AppColors.sageInk : AppColors.danger,
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: AppValues.space_22,
        child: SizedBox(
          width: AppValues.minTapTarget - 6,
          height: AppValues.minTapTarget - 6,
          child: Icon(icon, size: AppValues.icon_18, color: color),
        ),
      ),
    );
  }
}

/// Bangla body text with the search terms marked.
///
/// The match is on the raw term rather than a word boundary: Bangla attaches
/// its case endings straight onto the stem, so `নামাজ` has to light up inside
/// `নামাজের` or the highlight misses most of what the user actually found.
class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
  });

  final String text;
  final String query;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final terms = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 1)
        .toList();
    if (terms.isEmpty) return Text(text, style: style);

    final pattern = RegExp(
      terms.map(RegExp.escape).join('|'),
      caseSensitive: false,
    );

    final spans = <TextSpan>[];
    var index = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > index) {
        spans.add(TextSpan(text: text.substring(index, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(
            backgroundColor: AppColors.goldTint,
            color: AppColors.goldTintInk,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      index = match.end;
    }
    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index)));
    }

    return Text.rich(TextSpan(style: style, children: spans));
  }
}
