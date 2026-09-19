/// A dhikr the counter can be set to.
///
/// The set is fixed rather than user-editable, and deliberately short. The
/// audience is not looking for a configurable counter; they are looking for
/// the six phrases they already say, with the right target already filled in.
class DhikrPreset {
  const DhikrPreset({
    required this.id,
    required this.arabic,
    required this.bangla,
    required this.transliteration,
    required this.defaultTarget,
    required this.meaning,
  });

  /// Stable key for the log table. Never localised.
  final String id;

  final String arabic;
  final String bangla;

  /// How it is pronounced, which matters because much of the audience reads
  /// Arabic slowly but wants to say it correctly.
  final String transliteration;

  /// The count traditionally associated with this dhikr.
  final int defaultTarget;

  final String meaning;
}

/// The tasbih after each prayer, then the phrases people reach for outside it.
const List<DhikrPreset> dhikrPresets = [
  DhikrPreset(
    id: 'subhanallah',
    arabic: 'سُبْحَانَ اللَّه',
    bangla: 'সুবহানাল্লাহ',
    transliteration: 'Subhanallah',
    defaultTarget: 33,
    meaning: 'আল্লাহ পবিত্র',
  ),
  DhikrPreset(
    id: 'alhamdulillah',
    arabic: 'الْحَمْدُ لِلَّه',
    bangla: 'আলহামদুলিল্লাহ',
    transliteration: 'Alhamdulillah',
    defaultTarget: 33,
    meaning: 'সকল প্রশংসা আল্লাহর',
  ),
  DhikrPreset(
    id: 'allahuakbar',
    arabic: 'اللَّهُ أَكْبَر',
    bangla: 'আল্লাহু আকবার',
    transliteration: 'Allahu Akbar',
    defaultTarget: 34,
    meaning: 'আল্লাহ সবচেয়ে বড়',
  ),
  DhikrPreset(
    id: 'tahlil',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّه',
    bangla: 'লা ইলাহা ইল্লাল্লাহ',
    transliteration: 'La ilaha illallah',
    defaultTarget: 100,
    meaning: 'আল্লাহ ছাড়া কোনো ইলাহ নেই',
  ),
  DhikrPreset(
    id: 'istighfar',
    arabic: 'أَسْتَغْفِرُ اللَّه',
    bangla: 'আস্তাগফিরুল্লাহ',
    transliteration: 'Astaghfirullah',
    defaultTarget: 100,
    meaning: 'আমি আল্লাহর কাছে ক্ষমা চাই',
  ),
  DhikrPreset(
    id: 'durud',
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّد',
    bangla: 'দরুদ শরিফ',
    transliteration: 'Allahumma salli ala Muhammad',
    defaultTarget: 100,
    meaning: 'নবির প্রতি দরুদ',
  ),
];

DhikrPreset presetFor(String id) => dhikrPresets.firstWhere(
      (preset) => preset.id == id,
      orElse: () => dhikrPresets.first,
    );

/// One day's dhikr, as the history screen and the streak read it.
class DhikrDay {
  const DhikrDay({required this.date, required this.counts});

  DhikrDay.empty(this.date) : counts = const {};

  final DateTime date;

  /// Preset id → times counted that day.
  final Map<String, int> counts;

  int countOf(String dhikrId) => counts[dhikrId] ?? 0;

  int get total => counts.values.fold(0, (sum, value) => sum + value);

  bool get isEmpty => total == 0;
}

/// Derived figures shown on the counter card.
class TasbihSummary {
  const TasbihSummary({
    required this.todayTotal,
    required this.todayRounds,
    required this.streak,
    required this.allTime,
  });

  const TasbihSummary.empty()
      : todayTotal = 0,
        todayRounds = 0,
        streak = 0,
        allTime = 0;

  /// Every dhikr counted today, across presets.
  final int todayTotal;

  /// Completed rounds of the active dhikr today.
  final int todayRounds;

  /// Consecutive days with at least one dhikr counted. The bar is one, not a
  /// target: the habit worth rewarding is opening the app and remembering
  /// Allah at all, not hitting a number.
  final int streak;

  final int allTime;
}
