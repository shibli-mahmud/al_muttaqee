/// A collection in the bundled corpus.
class HadithBook {
  const HadithBook({
    required this.slug,
    required this.nameBn,
    required this.nameEn,
    required this.nameAr,
    required this.chapterCount,
    required this.hadithCount,
    required this.curated,
  });

  final String slug;
  final String nameBn;
  final String nameEn;
  final String nameAr;
  final int chapterCount;
  final int hadithCount;

  /// The curated entry point — ৪০ হাদিস নববি. It gets the gold treatment on
  /// the হাদিস screen because it is the one collection a newcomer can
  /// realistically finish, and finishing something is what brings them back.
  final bool curated;

  static HadithBook fromRow(Map<String, Object?> row) => HadithBook(
        slug: row['slug']! as String,
        nameBn: row['name_bn']! as String,
        nameEn: row['name_en']! as String,
        nameAr: row['name_ar']! as String,
        chapterCount: (row['chapter_count'] as int?) ?? 0,
        hadithCount: (row['hadith_count'] as int?) ?? 0,
        curated: ((row['curated'] as int?) ?? 0) == 1,
      );
}

/// One kitab inside a collection.
class HadithChapter {
  const HadithChapter({
    required this.book,
    required this.number,
    required this.nameBn,
    required this.nameEn,
    required this.hadithCount,
  });

  final String book;
  final int number;
  final String nameBn;
  final String nameEn;
  final int hadithCount;

  static HadithChapter fromRow(Map<String, Object?> row) => HadithChapter(
        book: row['book']! as String,
        number: (row['number'] as int?) ?? 0,
        nameBn: row['name_bn']! as String,
        nameEn: row['name_en']! as String,
        hadithCount: (row['hadith_count'] as int?) ?? 0,
      );
}

/// A single hadith.
class Hadith {
  const Hadith({
    required this.book,
    required this.number,
    required this.chapter,
    required this.arabic,
    required this.bengali,
    required this.grade,
  });

  final String book;
  final int number;
  final int chapter;
  final String arabic;
  final String bengali;

  /// The Al-Albani (or first available) grading, already in Bangla —
  /// সহিহ, হাসান, যঈফ and so on. Empty for Bukhari and Muslim, whose
  /// authenticity is not in question and where a badge would be noise.
  final String grade;

  /// Stable identity for bookmarks: `bukhari:1`.
  String get id => '$book:$number';

  static Hadith fromRow(Map<String, Object?> row) => Hadith(
        book: row['book']! as String,
        number: (row['number'] as int?) ?? 0,
        chapter: (row['chapter'] as int?) ?? 0,
        arabic: (row['arabic'] as String?) ?? '',
        bengali: (row['bengali'] as String?) ?? '',
        grade: (row['grade'] as String?) ?? '',
      );
}

/// A hadith plus the collection and chapter it came from, which a search
/// result or a bookmark needs in order to be readable out of context.
class HadithHit {
  const HadithHit({
    required this.hadith,
    required this.bookName,
    required this.chapterName,
  });

  final Hadith hadith;
  final String bookName;
  final String chapterName;
}
