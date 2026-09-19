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
import 'package:al_muttaqee/src/module/quran/controllers/quran_controller.dart';

/// আয়াত অ্যাকশন — frame ১৩.
///
/// Opened by a long press on an ayah. A tap does nothing, which is the point:
/// in the old build a tap started playback, and it fired constantly by
/// accident while people were reading.
Future<void> showAyahActionSheet({
  required BuildContext context,
  required QuranController controller,
  required int surah,
  required int ayah,
  required String arabic,
  required String translation,
  required String surahName,
}) async {
  final l10n = AppLocalizations.of(context)!;

  await Get.bottomSheet<void>(
    _AyahSheet(
      controller: controller,
      surah: surah,
      ayah: ayah,
      arabic: arabic,
      translation: translation,
      surahName: surahName,
      l10n: l10n,
    ),
    isScrollControlled: true,
    backgroundColor: AppColors.baseTransparent,
    barrierColor: AppColors.baseBlack.withValues(alpha: 0.3),
  );
}

class _AyahSheet extends StatelessWidget {
  const _AyahSheet({
    required this.controller,
    required this.surah,
    required this.ayah,
    required this.arabic,
    required this.translation,
    required this.surahName,
    required this.l10n,
  });

  final QuranController controller;
  final int surah;
  final int ayah;
  final String arabic;
  final String translation;
  final String surahName;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DuskRadius.sheet),
        ),
        boxShadow: AppColors.shadowSheet,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.space_12,
        AppValues.screenPadding,
        AppValues.space_24,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.grabHandle,
                  borderRadius: BorderRadius.circular(DuskRadius.chip),
                ),
              ),
            ),
            const SizedBox(height: AppValues.space_18),
            _header(),
            const SizedBox(height: AppValues.groupGap),
            Obx(() => _actions(context)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        DuskPill(
          label: '${formatNumberWithLocale(surah)} : '
              '${formatNumberWithLocale(ayah)}',
          background: AppColors.gold,
          foreground: AppColors.goldInk,
        ),
        const SizedBox(width: AppValues.gapSmall),
        Expanded(
          child: Text(
            l10n.quranAyahNumberLabel(ayah),
            style: DuskText.bangla(
              size: AppValues.fontSize_16,
              weight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        InkResponse(
          onTap: Get.back,
          radius: AppValues.space_22,
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.mutedChip,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              PhosphorIconsBold.x,
              size: AppValues.iconSmall,
              color: AppColors.inkSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    final bookmarked = controller.isBookmarked(surah, ayah);
    final note = controller.noteFor(surah, ayah);

    return GroupedCard(
      children: [
        // Bookmark gets the gold chip: it is by far the most-used action here,
        // and the sheet should make that obvious rather than presenting six
        // identical rows.
        GroupedRow(
          title: bookmarked
              ? l10n.quranRemoveBookmark
              : l10n.quranAddBookmark,
          titleStyle: DuskText.bangla(
            size: AppValues.fontSize_14_5,
            weight: FontWeight.w600,
            color: AppColors.ink,
          ),
          leading: DuskIconChip(
            icon: bookmarked
                ? PhosphorIconsFill.bookmarkSimple
                : PhosphorIconsRegular.bookmarkSimple,
            background: AppColors.goldTint,
            foreground: AppColors.goldOnIvory,
          ),
          onTap: () {
            controller.toggleBookmark(surah, ayah);
            Get.back<void>();
          },
        ),
        GroupedRow(
          title: note == null || note.isEmpty
              ? l10n.quranWriteNote
              : l10n.quranEditNote,
          titleStyle: DuskText.bangla(
            size: AppValues.fontSize_14_5,
            weight: FontWeight.w600,
            color: AppColors.ink,
          ),
          subtitle: note,
          leading: const DuskIconChip(
            icon: PhosphorIconsRegular.pencilSimple,
          ),
          onTap: () async {
            Get.back<void>();
            await _editNote(context, note ?? '');
          },
        ),
        GroupedRow(
          title: l10n.quranPlayFromHere,
          titleStyle: DuskText.bangla(
            size: AppValues.fontSize_14_5,
            weight: FontWeight.w600,
            color: AppColors.ink,
          ),
          leading: const DuskIconChip(icon: PhosphorIconsFill.play),
          onTap: () {
            Get.back<void>();
            controller.playAyah(surah, ayah);
          },
        ),
        GroupedRow(
          title: l10n.quranCopyAyah,
          titleStyle: DuskText.bangla(
            size: AppValues.fontSize_14_5,
            weight: FontWeight.w600,
            color: AppColors.ink,
          ),
          leading: const DuskIconChip(icon: PhosphorIconsRegular.copy),
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                text: '$arabic\n\n$translation\n\n'
                    '$surahName · ${formatNumberWithLocale(ayah)}',
              ),
            );
            Get.back<void>();
          },
        ),
      ],
    );
  }

  Future<void> _editNote(BuildContext context, String existing) async {
    final field = TextEditingController(text: existing);

    await Get.bottomSheet<void>(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.ivory,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(DuskRadius.sheet),
            ),
            boxShadow: AppColors.shadowSheet,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppValues.screenPadding,
            AppValues.space_18,
            AppValues.screenPadding,
            AppValues.space_24,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$surahName · ${formatNumberWithLocale(ayah)}',
                  style: DuskText.cardHeading,
                ),
                const SizedBox(height: AppValues.space_12),
                TextField(
                  controller: field,
                  autofocus: true,
                  maxLines: 5,
                  minLines: 3,
                  style: DuskText.bodyTight.copyWith(color: AppColors.inkBody),
                  decoration: InputDecoration(
                    hintText: l10n.quranNoteHint,
                    hintStyle: DuskText.bodyTight
                        .copyWith(color: AppColors.inkMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DuskRadius.inner),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.space_18),
                DuskPrimaryButton(
                  label: l10n.quranSaveNote,
                  icon: PhosphorIconsRegular.check,
                  onPressed: () {
                    controller.saveNote(surah, ayah, field.text);
                    Get.back<void>();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }
}
