import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/module/tasbih/data/tasbih_repository.dart';
import 'package:al_muttaqee/src/module/tasbih/models/tasbih_models.dart';

/// তাসবিহ — frame ০৭.
///
/// The counter now keeps what it counts. The previous build held the tally in
/// memory only, so backgrounding the app in the middle of a hundred durud
/// threw it away — which is the one thing a counter must never do.
class TasbihController extends BaseController {
  static TasbihController get to => Get.find<TasbihController>();

  TasbihController({
    TasbihRepository? repository,
    PreferenceManager? prefs,
  })  : _repository = repository ?? TasbihRepository(),
        _prefs = prefs ?? PreferenceManagerImpl.to;

  final TasbihRepository _repository;
  final PreferenceManager _prefs;

  /// Which dhikr the counter is set to.
  final activeDhikr = dhikrPresets.first.obs;

  /// Counted today for the active dhikr. This is the big number.
  final count = 0.obs;

  /// Target for one round. Starts at the dhikr's traditional count and can be
  /// overridden per dhikr.
  final target = dhikrPresets.first.defaultTarget.obs;

  final summary = const TasbihSummary.empty().obs;

  /// Haptics on each count. On by default — the tap is the whole interaction,
  /// and without feedback people lose their place when their eyes are closed.
  final hapticsEnabled = true.obs;

  final isLoading = true.obs;

  /// Pulses when a round completes, so the view can run its flourish without
  /// the controller knowing anything about animation.
  final roundJustCompleted = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      hapticsEnabled.value = await _prefs.getBool(
        AppStrings.spTasbihHaptics,
        defaultValue: true,
      );

      final savedId = await _prefs.getString(
        AppStrings.spTasbihActiveDhikr,
        defaultValue: dhikrPresets.first.id,
      );
      activeDhikr.value = presetFor(savedId);
      target.value = await _targetFor(activeDhikr.value);

      await _refresh();
    } catch (e, st) {
      logger.e('TasbihController._load: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> _targetFor(DhikrPreset preset) => _prefs.getInt(
        '${AppStrings.spTasbihTargetPrefix}.${preset.id}',
        defaultValue: preset.defaultTarget,
      );

  Future<void> _refresh() async {
    final day = await _repository.day(DateTime.now());
    count.value = day.countOf(activeDhikr.value.id);
    summary.value = await _repository.summary(
      activeDhikr: activeDhikr.value.id,
      target: target.value,
    );
  }

  // ── Counting ──────────────────────────────────────────────────────────────

  /// Where the current round sits, 0..target.
  int get progressInRound {
    if (target.value <= 0) return 0;
    final within = count.value % target.value;
    // A count that lands exactly on the target reads as a full ring, not an
    // empty one — the user has just finished, and the ring should say so
    // until the next tap starts the new round.
    return within == 0 && count.value > 0 ? target.value : within;
  }

  double get progress =>
      target.value <= 0 ? 0 : progressInRound / target.value;

  /// One count. Optimistic: the number moves on the frame the finger lifts and
  /// the write follows, because a counter that waits on disk feels broken.
  Future<void> increment() async {
    final next = count.value + 1;
    count.value = next;

    final completedRound = target.value > 0 && next % target.value == 0;
    if (hapticsEnabled.value) {
      if (completedRound) {
        // A distinctly heavier tap at the end of a round, so the user knows
        // they are done without looking.
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }
    if (completedRound) roundJustCompleted.value++;

    try {
      await _repository.add(activeDhikr.value.id, 1);
      summary.value = await _repository.summary(
        activeDhikr: activeDhikr.value.id,
        target: target.value,
      );
    } catch (e, st) {
      logger.e('TasbihController.increment: $e\n$st');
      count.value = next - 1;
    }
  }

  /// Undo a miscount. Never goes below zero.
  Future<void> decrement() async {
    if (count.value <= 0) return;
    count.value = count.value - 1;
    if (hapticsEnabled.value) HapticFeedback.selectionClick();

    try {
      await _repository.add(activeDhikr.value.id, -1);
      await _refresh();
    } catch (e, st) {
      logger.e('TasbihController.decrement: $e\n$st');
      count.value = count.value + 1;
    }
  }

  /// Clears today's count for this dhikr. The history of other days stays.
  Future<void> resetCount() async {
    if (hapticsEnabled.value) HapticFeedback.mediumImpact();
    count.value = 0;
    try {
      await _repository.reset(activeDhikr.value.id);
      await _refresh();
    } catch (e, st) {
      logger.e('TasbihController.resetCount: $e\n$st');
      await _refresh();
    }
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  Future<void> selectDhikr(DhikrPreset preset) async {
    if (preset.id == activeDhikr.value.id) return;
    if (hapticsEnabled.value) HapticFeedback.selectionClick();

    activeDhikr.value = preset;
    target.value = await _targetFor(preset);
    await _prefs.setString(AppStrings.spTasbihActiveDhikr, preset.id);
    await _refresh();
  }

  Future<void> setTarget(int value) async {
    if (value <= 0) return;
    target.value = value;
    await _prefs.setInt(
      '${AppStrings.spTasbihTargetPrefix}.${activeDhikr.value.id}',
      value,
    );
    await _refresh();
  }

  Future<void> toggleHaptics() async {
    hapticsEnabled.value = !hapticsEnabled.value;
    if (hapticsEnabled.value) HapticFeedback.mediumImpact();
    await _prefs.setBool(AppStrings.spTasbihHaptics, hapticsEnabled.value);
  }

  Future<List<DhikrDay>> history({int days = 30}) =>
      _repository.recent(days: days);

  void openHistory() => Get.toNamed(Routes.tasbihHistory);

  /// The target choices offered by the goal sheet. Covers the traditional
  /// counts plus the round numbers people set for themselves.
  static const List<int> targetOptions = [33, 34, 99, 100, 300, 500, 1000];
}
