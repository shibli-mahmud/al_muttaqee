import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

/// How a prayer ended up being recorded for a given day.
enum PrayerLogStatus {
  /// Prayed in its window.
  prayed,

  /// The window closed unlogged. Written by the day roll-over, never by a tap.
  missed,

  /// Made up after the window closed.
  qada,
}

/// The five daily prayers, in order. Sunrise is not one of them — it marks the
/// end of the Fajr window rather than a prayer, which is why the নামাজ list
/// shows it without a tracker circle.
const List<PrayerName> trackedPrayers = [
  PrayerName.fajr,
  PrayerName.dhuhr,
  PrayerName.asr,
  PrayerName.maghrib,
  PrayerName.isha,
];

/// One row of `prayer_log`.
class PrayerLogEntry {
  const PrayerLogEntry({
    required this.date,
    required this.prayer,
    required this.status,
    required this.loggedAt,
  });

  /// Local calendar day, normalised to midnight. Stored as `yyyy-MM-dd` so a
  /// month query is a string range rather than a timestamp comparison.
  final DateTime date;

  final PrayerName prayer;
  final PrayerLogStatus status;
  final DateTime loggedAt;

  bool get counts =>
      status == PrayerLogStatus.prayed || status == PrayerLogStatus.qada;

  Map<String, Object?> toRow() => {
        'date': dateKey(date),
        'prayer': prayer.name,
        'status': status.name,
        'logged_at': loggedAt.toIso8601String(),
      };

  static PrayerLogEntry fromRow(Map<String, Object?> row) => PrayerLogEntry(
        date: DateTime.parse(row['date']! as String),
        prayer: PrayerName.values.firstWhere(
          (p) => p.name == row['prayer'],
          orElse: () => PrayerName.fajr,
        ),
        status: PrayerLogStatus.values.firstWhere(
          (s) => s.name == row['status'],
          orElse: () => PrayerLogStatus.prayed,
        ),
        loggedAt: DateTime.parse(row['logged_at']! as String),
      );
}

/// `yyyy-MM-dd` for a local date. Sortable as a string, which is what the
/// month-range queries rely on.
String dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// The local calendar day [moment] falls in.
DateTime dayOf(DateTime moment) =>
    DateTime(moment.year, moment.month, moment.day);

/// How many of the five prayers were logged on one day, and which.
class DayLog {
  const DayLog({required this.date, required this.statuses});

  DayLog.empty(this.date) : statuses = const {};

  final DateTime date;
  final Map<PrayerName, PrayerLogStatus> statuses;

  PrayerLogStatus? statusOf(PrayerName prayer) => statuses[prayer];

  bool isLogged(PrayerName prayer) {
    final status = statuses[prayer];
    return status == PrayerLogStatus.prayed || status == PrayerLogStatus.qada;
  }

  int get completed => trackedPrayers.where(isLogged).length;

  bool get isComplete => completed == trackedPrayers.length;

  bool get isEmpty => completed == 0;
}

/// Derived streak and monthly totals. Recomputed from the log rather than
/// stored, then cached in the controller — a stored counter drifts the first
/// time a write fails, and a wrong streak is worse than a slow one.
class TrackerSummary {
  const TrackerSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.monthCompleted,
    required this.monthPossible,
  });

  const TrackerSummary.empty()
      : currentStreak = 0,
        longestStreak = 0,
        monthCompleted = 0,
        monthPossible = 0;

  /// Consecutive days, counting back from today, on which all five were
  /// logged. Today is only allowed to break the streak once it is over — an
  /// incomplete today leaves yesterday's streak standing.
  final int currentStreak;

  final int longestStreak;

  /// Prayers logged this month, and how many were possible by now — the
  /// `১৪২ / ১৫০` pair on the month tracker card.
  final int monthCompleted;
  final int monthPossible;
}
