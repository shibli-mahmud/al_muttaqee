import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';

/// A day marked on the calendar.
class IslamicEvent {
  const IslamicEvent({
    required this.key,
    required this.hijriMonth,
    required this.hijriDay,
    this.major = false,
  });

  /// Localisation key for the name.
  final String key;

  final int hijriMonth;
  final int hijriDay;

  /// The two Eids and Laylatul Qadr, which get the gold treatment.
  final bool major;
}

const List<IslamicEvent> islamicEvents = [
  IslamicEvent(key: 'ashura', hijriMonth: 1, hijriDay: 10),
  IslamicEvent(key: 'mawlid', hijriMonth: 3, hijriDay: 12),
  IslamicEvent(key: 'shabeMeraj', hijriMonth: 7, hijriDay: 27),
  IslamicEvent(key: 'shabeBarat', hijriMonth: 8, hijriDay: 15, major: true),
  IslamicEvent(key: 'ramadanStart', hijriMonth: 9, hijriDay: 1, major: true),
  IslamicEvent(key: 'laylatulQadr', hijriMonth: 9, hijriDay: 27, major: true),
  IslamicEvent(key: 'eidAlFitr', hijriMonth: 10, hijriDay: 1, major: true),
  IslamicEvent(key: 'arafah', hijriMonth: 12, hijriDay: 9),
  IslamicEvent(key: 'eidAlAdha', hijriMonth: 12, hijriDay: 10, major: true),
];

/// হিজরি ক্যালেন্ডার — frame ১৯.
///
/// The Hijri date is user-adjustable by a day in either direction. This is not
/// a nicety: the calculated Hijri date and the date announced by the moon
/// sighting committee in Bangladesh routinely differ by one, and an app that
/// puts Eid on the wrong day is an app people delete.
class IslamicCalendarController extends BaseController {
  static IslamicCalendarController get to =>
      Get.find<IslamicCalendarController>();

  IslamicCalendarController({PreferenceManager? prefs})
      : _prefs = prefs ?? PreferenceManagerImpl.to;

  final PreferenceManager _prefs;

  /// Any Gregorian day inside the Hijri month being shown.
  final anchor = DateTime.now().obs;

  /// −1, 0 or +1 days applied to every Hijri conversion.
  final hijriOffset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    hijriOffset.value = await _prefs.getInt(AppStrings.spHijriOffset);
  }

  Future<void> setHijriOffset(int value) async {
    hijriOffset.value = value.clamp(-1, 1);
    await _prefs.setInt(AppStrings.spHijriOffset, hijriOffset.value);
  }

  /// The Hijri date for a Gregorian day, with the user's correction applied.
  HijriCalendar hijriFor(DateTime date) =>
      HijriCalendar.fromDate(date.add(Duration(days: hijriOffset.value)));

  HijriCalendar get shownMonth => hijriFor(anchor.value);

  void previousMonth() =>
      anchor.value = anchor.value.subtract(const Duration(days: 29));

  void nextMonth() => anchor.value = anchor.value.add(const Duration(days: 29));

  void goToToday() => anchor.value = DateTime.now();

  bool get isCurrentMonth {
    final now = hijriFor(DateTime.now());
    final shown = shownMonth;
    return now.hMonth == shown.hMonth && now.hYear == shown.hYear;
  }

  /// Every Gregorian day that falls in the Hijri month on screen.
  ///
  /// Walked outward from the anchor rather than computed, because converting
  /// a Hijri month back to its Gregorian span is exactly the arithmetic the
  /// offset is there to correct.
  List<DateTime> daysOfMonth() {
    final target = shownMonth;
    final days = <DateTime>[];

    var cursor = DateTime(
      anchor.value.year,
      anchor.value.month,
      anchor.value.day,
    );
    // Back up to the first day of the Hijri month.
    for (var i = 0; i < 40; i++) {
      final previous = cursor.subtract(const Duration(days: 1));
      final hijri = hijriFor(previous);
      if (hijri.hMonth != target.hMonth || hijri.hYear != target.hYear) break;
      cursor = previous;
    }
    // Then walk forward to its end.
    for (var i = 0; i < 31; i++) {
      final day = cursor.add(Duration(days: i));
      final hijri = hijriFor(day);
      if (hijri.hMonth != target.hMonth || hijri.hYear != target.hYear) break;
      days.add(day);
    }
    return days;
  }

  IslamicEvent? eventOn(DateTime date) {
    final hijri = hijriFor(date);
    for (final event in islamicEvents) {
      if (event.hijriMonth == hijri.hMonth && event.hijriDay == hijri.hDay) {
        return event;
      }
    }
    return null;
  }

  /// The events falling in the month on screen, with their Gregorian dates.
  List<(IslamicEvent, DateTime)> eventsThisMonth() {
    final result = <(IslamicEvent, DateTime)>[];
    for (final day in daysOfMonth()) {
      final event = eventOn(day);
      if (event != null) result.add((event, day));
    }
    return result;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
