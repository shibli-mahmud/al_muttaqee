import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart'
    show dayOf;

/// A pointer to one ayah. Value type, so it works as a map key and a set
/// member without any ceremony.
class AyahRef {
  const AyahRef(this.surah, this.ayah);

  final int surah;
  final int ayah;

  @override
  bool operator ==(Object other) =>
      other is AyahRef && other.surah == surah && other.ayah == ayah;

  @override
  int get hashCode => Object.hash(surah, ayah);

  @override
  String toString() => '$surah:$ayah';
}

/// One day's reading.
class ReadingDay {
  const ReadingDay({
    required this.date,
    required this.ayahsRead,
    required this.secondsRead,
    required this.lastSurah,
    required this.lastAyah,
  });

  ReadingDay.empty(this.date)
      : ayahsRead = 0,
        secondsRead = 0,
        lastSurah = 0,
        lastAyah = 0;

  final DateTime date;
  final int ayahsRead;
  final int secondsRead;
  final int lastSurah;
  final int lastAyah;

  int get minutesRead => (secondsRead / 60).round();

  bool get isEmpty => ayahsRead == 0 && secondsRead == 0;

  static ReadingDay fromRow(Map<String, Object?> row) => ReadingDay(
        date: dayOf(DateTime.parse(row['date']! as String)),
        ayahsRead: (row['ayahs_read'] as int?) ?? 0,
        secondsRead: (row['seconds_read'] as int?) ?? 0,
        lastSurah: (row['last_surah'] as int?) ?? 0,
        lastAyah: (row['last_ayah'] as int?) ?? 0,
      );
}

/// How the user has chosen to pace themselves.
enum ReadingPlanType {
  /// A fixed number of ayahs a day.
  ayahs,

  /// One para a day — the Ramadan pace, a khatm in thirty days.
  para,

  /// A fixed number of minutes, for readers who would rather not count.
  minutes,

  /// Surah al-Kahf every Friday, which is a habit rather than a rate.
  weekly,
}

class ReadingPlan {
  const ReadingPlan({required this.type, required this.target});

  const ReadingPlan.none()
      : type = ReadingPlanType.ayahs,
        target = 0;

  final ReadingPlanType type;

  /// Ayahs, paras or minutes depending on [type]; unused for [weekly].
  final int target;

  bool get isSet => target > 0 || type == ReadingPlanType.weekly;

  /// A para averages 236 ayahs, which is close enough to turn a para-a-day
  /// plan into a daily ayah target for the progress ring.
  static const int ayahsPerPara = 236;

  /// How many ayahs a day this plan works out to, for progress. Minute-based
  /// and weekly plans have no ayah target, so they report zero and the UI
  /// measures them their own way.
  int get dailyAyahTarget => switch (type) {
        ReadingPlanType.ayahs => target,
        ReadingPlanType.para => target * ayahsPerPara,
        ReadingPlanType.minutes => 0,
        ReadingPlanType.weekly => 0,
      };

  /// Roughly how long a khatm takes at this pace, in days. The whole Quran is
  /// 6,236 ayahs.
  int? get daysToKhatm {
    final daily = dailyAyahTarget;
    if (daily <= 0) return null;
    return (6236 / daily).ceil();
  }
}

/// A reader reads about six ayahs a minute at an unhurried pace, which is what
/// turns "eight ayahs left" into "about four minutes".
const double ayahsPerMinute = 2.0;
