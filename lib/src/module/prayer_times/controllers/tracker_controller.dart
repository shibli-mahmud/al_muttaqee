import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/shared/widgets/dusk/tracker_circle.dart';
import 'package:al_muttaqee/src/module/prayer_times/controllers/prayer_times_controller.dart';
import 'package:al_muttaqee/src/module/prayer_times/data/prayer_log_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// The prayer tracker: today's five circles on হোম, the row circles and the
/// month heatmap on নামাজ, and the streak that ties them together.
///
/// The tracker is the retention feature of the redesign. Everything else in the
/// app answers a question the user already had; this one gives them a reason to
/// come back, so its writes are optimistic — the circle changes the instant it
/// is tapped and the database catches up — and a failed write rolls the circle
/// back rather than leaving the two out of step.
class TrackerController extends BaseController {
  static TrackerController get to => Get.find<TrackerController>();

  TrackerController({PrayerLogRepository? repository})
      : _repository = repository ?? PrayerLogRepository();

  final PrayerLogRepository _repository;

  final today = Rx<DayLog>(DayLog.empty(DateTime.now()));
  final summary = const TrackerSummary.empty().obs;

  /// The month the নামাজ heatmap is showing, day-of-month → log.
  final monthLog = <int, DayLog>{}.obs;
  final visibleMonth = Rx<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month),
  );

  PrayerTimesController? get _prayerTimes =>
      Get.isRegistered<PrayerTimesController>()
          ? PrayerTimesController.to
          : null;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    await Future.wait([_loadToday(), _loadMonth()]);
    await _loadSummary();
  }

  Future<void> _loadToday() async {
    try {
      today.value = await _repository.dayLog(DateTime.now());
    } catch (e, st) {
      logger.e('TrackerController._loadToday: $e\n$st');
    }
  }

  Future<void> _loadMonth() async {
    try {
      monthLog.value = await _repository.monthLog(visibleMonth.value);
    } catch (e, st) {
      logger.e('TrackerController._loadMonth: $e\n$st');
    }
  }

  Future<void> _loadSummary() async {
    try {
      summary.value = await _repository.summary(
        today: DateTime.now(),
        prayersPossibleToday: _prayerTimes?.prayersElapsedToday ?? 0,
      );
    } catch (e, st) {
      logger.e('TrackerController._loadSummary: $e\n$st');
    }
  }

  Future<void> showMonth(DateTime month) async {
    visibleMonth.value = DateTime(month.year, month.month);
    await _loadMonth();
  }

  /// Logs or unlogs [prayer] for today — the tap on a tracker circle.
  ///
  /// A prayer whose window has not opened yet cannot be logged. Letting someone
  /// tick Isha at nine in the morning would make the streak meaningless, and
  /// the streak is the whole point.
  Future<void> togglePrayerLogged(PrayerName prayer) async {
    if (!canLog(prayer)) return;

    final wasLogged = today.value.isLogged(prayer);
    final statuses =
        Map<PrayerName, PrayerLogStatus>.from(today.value.statuses);

    if (wasLogged) {
      statuses.remove(prayer);
    } else {
      // Past its window but being ticked now — that is qada, and recording it
      // as such keeps the history honest while still counting toward the day.
      statuses[prayer] = _windowHasClosed(prayer)
          ? PrayerLogStatus.qada
          : PrayerLogStatus.prayed;
    }

    // Optimistic: the circle moves on the frame the finger lifts.
    today.value = DayLog(date: dayOf(DateTime.now()), statuses: statuses);

    try {
      if (wasLogged) {
        await _repository.unlog(DateTime.now(), prayer);
      } else {
        await _repository.log(
          DateTime.now(),
          prayer,
          status: statuses[prayer] ?? PrayerLogStatus.prayed,
        );
      }
      await Future.wait([_loadMonth(), _loadSummary()]);
    } catch (e, st) {
      logger.e('TrackerController.togglePrayerLogged: $e\n$st');
      await _loadToday();
    }
  }

  /// A prayer can be logged once its window has opened.
  bool canLog(PrayerName prayer) {
    if (prayer == PrayerName.sunrise) return false;
    final entry = _prayerTimes?.dayTimes.value?.entryFor(prayer);
    if (entry == null) return false;
    return !DateTime.now().isBefore(entry.time);
  }

  bool _windowHasClosed(PrayerName prayer) {
    final times = _prayerTimes?.dayTimes.value;
    if (times == null) return false;
    // The window runs until the next prayer starts; Isha runs to the day's end.
    final order = trackedPrayers;
    final index = order.indexOf(prayer);
    if (index < 0) return false;
    if (index == order.length - 1) return false;
    final next = times.entryFor(order[index + 1]);
    return next != null && !DateTime.now().isBefore(next.time);
  }

  /// What a circle should look like for [prayer] today.
  TrackerState stateFor(PrayerName prayer) {
    if (today.value.isLogged(prayer)) return TrackerState.done;
    if (!canLog(prayer)) return TrackerState.future;
    return _windowHasClosed(prayer) ? TrackerState.missed : TrackerState.due;
  }

  /// How many of the five have been logged today.
  int get completedToday => today.value.completed;

  int get currentStreak => summary.value.currentStreak;
}
