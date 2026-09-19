import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_values.dart';
import 'package:al_muttaqee/src/core/constants/dusk_text_styles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/dusk.dart';
import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';
import 'package:al_muttaqee/src/module/masjid_finder/controllers/masjid_finder_controller.dart';
import 'package:al_muttaqee/src/module/masjid_finder/models/masjid.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// মসজিদ ও জামাত — frame ১৮.
///
/// Jamaat time is the content and distance is the qualifier, not the other way
/// round. Nobody in Dhaka is short of mosques; they are short of knowing which
/// one prays Asr at 4:30.
class MasjidFinderView extends BaseView<MasjidFinderController> {
  MasjidFinderView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() => AppColors.ivory;

  @override
  Color statusBarColor() => AppColors.baseTransparent;

  @override
  Widget pageContent(BuildContext context) => body(context);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const theme = DuskHeroTheme.day;

    return Obx(
      () => Column(
        children: [
          DuskHero(
            theme: theme,
            paddingBottom: AppValues.cardPadding,
            child: DuskHeroTitleRow(
              title: l10n.masjidFinder,
              theme: theme,
              onBack: Get.back,
              actions: [
                DuskHeroIconButton(
                  icon: PhosphorIconsRegular.arrowsClockwise,
                  theme: theme,
                  semanticLabel: l10n.retry,
                  onTap: controller.refreshMasjids,
                ),
              ],
            ),
          ),
          Expanded(child: _content(l10n)),
        ],
      ),
    );
  }

  Widget _content(AppLocalizations l10n) {
    if (controller.apiKeyMissing.value) {
      return Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: DuskErrorPanel(
          title: l10n.masjidKeyMissingTitle,
          message: l10n.mapsApiKeyRequired,
          actionLabel: l10n.retry,
          onAction: controller.refreshMasjids,
        ),
      );
    }

    if (!controller.locationAvailable.value) {
      return Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: DuskErrorPanel(
          title: l10n.locationDeniedTitle,
          message: l10n.masjidLocationNeeded,
          actionLabel: l10n.retry,
          onAction: controller.refreshMasjids,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppValues.space_24),
      children: [
        _map(l10n),
        const SizedBox(height: AppValues.groupGap),
        _filters(l10n),
        const SizedBox(height: AppValues.space_12),
        if (controller.isLoading.value)
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                0,
                AppValues.screenPadding,
                AppValues.cardGap,
              ),
              child: DuskSkeleton(
                width: double.infinity,
                height: 96,
                radius: DuskRadius.card,
              ),
            ),
          )
        else if (controller.masjids.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppValues.space_24),
            child: DuskEmptyState(
              icon: PhosphorIconsRegular.mosque,
              message: l10n.noNearbyMasjids,
              actionLabel: l10n.retry,
              onAction: controller.refreshMasjids,
            ),
          )
        else
          for (final masjid in controller.masjids)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                0,
                AppValues.screenPadding,
                AppValues.cardGap,
              ),
              child: _MasjidCard(
                masjid: masjid,
                controller: controller,
                expanded: controller.selected.value?.id == masjid.id,
                l10n: l10n,
              ),
            ),
      ],
    );
  }

  // ── Map ───────────────────────────────────────────────────────────────────

  Widget _map(AppLocalizations l10n) {
    final selected = controller.selected.value;
    final line = controller.route.value;

    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.position.value,
                zoom: 15,
              ),
              onMapCreated: controller.onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: {
                for (final masjid in controller.masjids)
                  Marker(
                    markerId: MarkerId(masjid.id),
                    position: LatLng(masjid.latitude, masjid.longitude),
                    infoWindow: InfoWindow(title: masjid.name),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      masjid.id == selected?.id
                          ? BitmapDescriptor.hueOrange
                          : BitmapDescriptor.hueGreen,
                    ),
                    onTap: () => controller.select(masjid),
                  ),
              },
              polylines: {
                if (line != null && line.points.length > 1)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: line.points,
                    color: AppColors.duskMid,
                    width: 5,
                    // A dashed line when it is only the straight-line
                    // fallback, so the map does not imply a path that was
                    // never routed.
                    patterns: line.isEstimate
                        ? [PatternItem.dash(18), PatternItem.gap(10)]
                        : const [],
                  ),
              },
            ),
          ),
          Positioned(
            left: AppValues.screenPadding,
            bottom: AppValues.space_12,
            child: _MapPill(
              label: l10n.masjidCountWithin(
                formatNumberWithLocale(controller.masjids.length),
                formatNumberWithLocale(controller.radiusKm.value.round()),
              ),
            ),
          ),
          if (line != null)
            Positioned(
              right: AppValues.screenPadding,
              bottom: AppValues.space_12,
              child: _MapPill(
                label: line.isEstimate
                    ? l10n.masjidStraightLine(
                        formatNumberWithLocale(
                          (line.distanceMetres).round(),
                        ),
                      )
                    : l10n.masjidWalkMinutes(
                        formatNumberWithLocale(line.walkMinutes),
                      ),
                icon: line.isEstimate
                    ? PhosphorIconsRegular.arrowsOutSimple
                    : PhosphorIconsRegular.personSimpleWalk,
              ),
            ),
        ],
      ),
    );
  }

  Widget _filters(AppLocalizations l10n) {
    final options = <MasjidSort, String>{
      MasjidSort.distance: l10n.masjidSortDistance,
      MasjidSort.jamaat: l10n.masjidSortJamaat,
      MasjidSort.jumua: l10n.masjidSortJumua,
    };

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.screenPadding,
        ),
        children: [
          for (final entry in options.entries) ...[
            DuskPill(
              label: entry.value,
              background: controller.sort.value == entry.key
                  ? AppColors.duskDeep
                  : AppColors.surface,
              foreground: controller.sort.value == entry.key
                  ? AppColors.onDeepPrimary
                  : AppColors.inkSecondary,
              onTap: () => controller.setSort(entry.key),
            ),
            const SizedBox(width: AppValues.space_7),
          ],
        ],
      ),
    );
  }
}

class _MapPill extends StatelessWidget {
  const _MapPill({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.gap_6,
        horizontal: AppValues.space_12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(DuskRadius.chip),
        boxShadow: AppColors.shadowCard,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppValues.iconXSmall, color: AppColors.duskMid),
            const SizedBox(width: AppValues.gap_5),
          ],
          Text(
            label,
            style: DuskText.chip.copyWith(color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

/// One masjid.
///
/// The selected one expands to show the jamaat strip and the two actions; the
/// rest stay one line so the list can be scanned.
class _MasjidCard extends StatelessWidget {
  const _MasjidCard({
    required this.masjid,
    required this.controller,
    required this.expanded,
    required this.l10n,
  });

  final Masjid masjid;
  final MasjidFinderController controller;
  final bool expanded;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return DuskCard(
      radius: DuskRadius.card,
      border: expanded ? Border.all(color: AppColors.goldTintBorder) : null,
      shadow: expanded ? AppColors.shadowCardRaised : AppColors.shadowCard,
      onTap: expanded ? null : () => controller.select(masjid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  masjid.name,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_16,
                    weight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: AppValues.gapXSmall),
              Text(
                l10n.distanceKm(
                  formatNumberWithLocale(
                    (masjid.distanceKm * 10).round() ~/ 10,
                  ),
                ),
                style: DuskText.bangla(
                  size: AppValues.fontSize_14,
                  weight: FontWeight.w700,
                  color: AppColors.goldOnIvory,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.gap_2),
          Text(
            _subtitle(),
            style: DuskText.rowSubtitle.copyWith(color: AppColors.inkMuted),
          ),
          if (expanded) ...[
            const SizedBox(height: AppValues.space_12),
            _jamaatStrip(context),
            const SizedBox(height: AppValues.space_12),
            _actions(context),
          ] else if (!masjid.hasJamaat) ...[
            const SizedBox(height: AppValues.gap_6),
            _AddJamaatLink(
              onTap: () => _editJamaat(context),
              label: l10n.masjidAddJamaatPrompt,
            ),
          ],
        ],
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[
      if (masjid.address.isNotEmpty) masjid.address,
      l10n.masjidWalkMinutes(formatNumberWithLocale(masjid.walkMinutes)),
    ];
    if (!masjid.hasJamaat) parts.add(l10n.jamaatUnknown);
    return parts.join(' · ');
  }

  /// Five cells, one per prayer, with the next jamaat picked out in gold.
  Widget _jamaatStrip(BuildContext context) {
    final next = controller.nextJamaatPrayer;

    return Row(
      children: [
        for (final prayer in trackedPrayers) ...[
          if (prayer != trackedPrayers.first)
            const SizedBox(width: AppValues.gap_5),
          Expanded(
            child: GestureDetector(
              onTap: () => _editJamaat(context, prayer: prayer),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppValues.gap_6,
                  horizontal: AppValues.gap_2,
                ),
                decoration: BoxDecoration(
                  color: prayer == next
                      ? AppColors.gold
                      : AppColors.neutralFill,
                  borderRadius: BorderRadius.circular(DuskRadius.iconChip),
                ),
                child: Column(
                  children: [
                    Text(
                      _prayerLabel(prayer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DuskText.bangla(
                        size: AppValues.fontSize_10,
                        weight: FontWeight.w600,
                        color: prayer == next
                            ? AppColors.goldInkSoft
                            : AppColors.inkMuted,
                      ),
                    ),
                    Text(
                      masjid.jamaat[prayer] == null
                          ? '—'
                          : formatClock(
                              masjid.jamaat[prayer]!.on(DateTime.now()),
                            ),
                      maxLines: 1,
                      style: DuskText.bangla(
                        size: AppValues.fontSize_12_5,
                        weight: FontWeight.w700,
                        color: prayer == next
                            ? AppColors.goldInk
                            : AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: l10n.masjidShowRoute,
            icon: PhosphorIconsFill.navigationArrow,
            background: AppColors.duskDeep,
            foreground: AppColors.onDeepPrimary,
            onTap: () => controller.openDirections(masjid),
          ),
        ),
        const SizedBox(width: AppValues.gapXSmall),
        Expanded(
          child: _ActionButton(
            label: l10n.masjidSetJamaat,
            icon: PhosphorIconsRegular.clock,
            background: AppColors.neutralFill,
            foreground: AppColors.inkSecondary,
            onTap: () => _editJamaat(context),
          ),
        ),
      ],
    );
  }

  String _prayerLabel(PrayerName prayer) => switch (prayer) {
        PrayerName.fajr => l10n.prayerFajr,
        PrayerName.sunrise => l10n.prayerSunrise,
        PrayerName.dhuhr => l10n.prayerDhuhr,
        PrayerName.asr => l10n.prayerAsr,
        PrayerName.maghrib => l10n.prayerMaghrib,
        PrayerName.isha => l10n.prayerIsha,
      };

  Future<void> _editJamaat(
    BuildContext context, {
    PrayerName? prayer,
  }) async {
    if (prayer != null) {
      await _pickTime(context, prayer);
      return;
    }

    await Get.bottomSheet<void>(
      Container(
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
              Text(masjid.name, style: DuskText.cardHeading),
              Text(
                l10n.masjidJamaatExplainer,
                style: DuskText.bodySmall
                    .copyWith(color: AppColors.inkSecondary),
              ),
              const SizedBox(height: AppValues.space_12),
              Obx(() {
                final current = controller.masjids.firstWhereOrNull(
                      (m) => m.id == masjid.id,
                    ) ??
                    masjid;
                return GroupedCard(
                  children: [
                    for (final prayer in trackedPrayers)
                      GroupedRow(
                        title: _prayerLabel(prayer),
                        leading: const DuskIconChip(
                          icon: PhosphorIconsRegular.clock,
                        ),
                        value: current.jamaat[prayer] == null
                            ? l10n.notSet
                            : formatClock(
                                current.jamaat[prayer]!.on(DateTime.now()),
                              ),
                        valueStyle: DuskText.rowTrailing.copyWith(
                          color: current.jamaat[prayer] == null
                              ? AppColors.inkMuted
                              : AppColors.ink,
                        ),
                        chevron: true,
                        onTap: () => _pickTime(context, prayer),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.baseTransparent,
    );
  }

  Future<void> _pickTime(BuildContext context, PrayerName prayer) async {
    final existing = masjid.jamaat[prayer];
    final picked = await showTimePicker(
      context: context,
      helpText: '${masjid.name} · ${_prayerLabel(prayer)}',
      initialTime: existing == null
          ? const TimeOfDay(hour: 5, minute: 0)
          : TimeOfDay(hour: existing.hour, minute: existing.minute),
    );
    if (picked == null) return;
    await controller.setJamaat(
      masjid,
      prayer,
      JamaatTime(picked.hour, picked.minute),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppValues.gap),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.space_11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppValues.iconSmall, color: foreground),
              const SizedBox(width: AppValues.gap_6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DuskText.bangla(
                    size: AppValues.fontSize_13,
                    weight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The crowd-sourcing prompt on a masjid whose times nobody has filled in.
class _AddJamaatLink extends StatelessWidget {
  const _AddJamaatLink({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.gap_4),
          child: Text(
            label,
            style: DuskText.bangla(
              size: AppValues.fontSize_12_5,
              weight: FontWeight.w700,
              color: AppColors.duskMid,
            ).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.duskMid,
            ),
          ),
        ),
      ),
    );
  }
}
