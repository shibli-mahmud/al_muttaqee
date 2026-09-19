/// Where in the corpus a dua came from.
class DuaSource {
  const DuaSource({required this.book, required this.chapter});

  final String book;
  final int chapter;
}

/// A dua, as the screen shows it.
class Dua {
  const Dua({
    required this.book,
    required this.number,
    required this.arabic,
    required this.bengali,
    required this.grade,
    required this.bookName,
  });

  final String book;
  final int number;
  final String arabic;
  final String bengali;
  final String grade;
  final String bookName;

  String get id => '$book:$number';

  static Dua fromRow(Map<String, Object?> row) => Dua(
        book: row['book']! as String,
        number: (row['number'] as int?) ?? 0,
        arabic: (row['arabic'] as String?) ?? '',
        bengali: (row['bengali'] as String?) ?? '',
        grade: (row['grade'] as String?) ?? '',
        bookName: (row['book_name'] as String?) ?? '',
      );
}

/// A way into the collection.
///
/// Each category is a full-text query rather than a stored tag, because the
/// corpus has no category column and inventing one by hand across 440 entries
/// would be guesswork. The queries are the Bangla words these supplications
/// actually use, which is both honest and easy to correct.
class DuaCategory {
  const DuaCategory({
    required this.id,
    required this.label,
    required this.query,
    required this.icon,
    this.count = 0,
    this.fromHour,
    this.toHour,
  });

  final String id;
  final String label;

  /// The FTS5 query behind this category.
  final String query;

  /// Phosphor icon name, resolved in the view.
  final String icon;

  final int count;

  /// When this category is the contextually useful one. The screen picks the
  /// active chip by the clock rather than making the user choose, because at
  /// eleven at night the answer is almost always the bedtime adhkar.
  final int? fromHour;
  final int? toHour;

  bool get isContextual => fromHour != null && toHour != null;

  bool matchesHour(int hour) {
    if (!isContextual) return false;
    final from = fromHour!;
    final to = toHour!;
    // Windows that wrap past midnight.
    return from <= to ? hour >= from && hour < to : hour >= from || hour < to;
  }

  DuaCategory withCount(int value) => DuaCategory(
        id: id,
        label: label,
        query: query,
        icon: icon,
        count: value,
        fromHour: fromHour,
        toHour: toHour,
      );
}

const List<DuaCategory> duaCategories = [
  DuaCategory(
    id: 'morning_evening',
    label: 'সকাল-সন্ধ্যা',
    query: '"সকাল" OR "সন্ধ্যা" OR "ভোর"',
    icon: 'sunHorizon',
    fromHour: 5,
    toHour: 11,
  ),
  DuaCategory(
    id: 'sleep',
    label: 'ঘুমানোর আগে',
    query: '"ঘুম" OR "শয্যা" OR "বিছানা"',
    icon: 'moon',
    fromHour: 21,
    toHour: 5,
  ),
  DuaCategory(
    id: 'food',
    label: 'খাওয়ার সময়',
    query: '"খাবার" OR "খাওয়া" OR "পান" OR "আহার"',
    icon: 'forkKnife',
    fromHour: 11,
    toHour: 15,
  ),
  DuaCategory(
    id: 'travel',
    label: 'সফরে',
    query: '"সফর" OR "ভ্রমণ" OR "সওয়ারি"',
    icon: 'airplaneTilt',
  ),
  DuaCategory(
    id: 'prayer',
    label: 'নামাজের দুআ',
    query: '"সালাত" OR "নামাজ" OR "সিজদা" OR "রুকু"',
    icon: 'handsPraying',
    fromHour: 15,
    toHour: 21,
  ),
  DuaCategory(
    id: 'distress',
    label: 'রোগ ও কষ্টে',
    query: '"রোগ" OR "অসুস্থ" OR "কষ্ট" OR "বিপদ" OR "দুশ্চিন্তা"',
    icon: 'heartbeat',
  ),
  DuaCategory(
    id: 'family',
    label: 'পরিবার',
    query: '"সন্তান" OR "স্ত্রী" OR "পরিবার" OR "পিতামাতা"',
    icon: 'users',
  ),
  DuaCategory(
    id: 'refuge',
    label: 'আশ্রয় প্রার্থনা',
    query: '"আশ্রয়" OR "পানাহ" OR "রক্ষা"',
    icon: 'shield',
  ),
  DuaCategory(
    id: 'forgiveness',
    label: 'ক্ষমা ও তাওবা',
    query: '"ক্ষমা" OR "তাওবা" OR "মাগফিরাত" OR "ইস্তিগফার"',
    icon: 'handHeart',
  ),
];

/// The category that fits the time of day, or the first one as a fallback.
DuaCategory contextualCategory(DateTime now) {
  for (final category in duaCategories) {
    if (category.matchesHour(now.hour)) return category;
  }
  return duaCategories.first;
}
