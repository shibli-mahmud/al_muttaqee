enum HadithBook {
  bukhari('bukhari'),
  muslim('muslim'),
  abuDaud('abuDaud'),
  ibnMajah('ibnMajah'),
  tirmidi('tirmidi');

  const HadithBook(this.apiSlug);
  final String apiSlug;
}

class HadithChapter {
  const HadithChapter({required this.number, required this.title});

  final int number;
  final String title;

  factory HadithChapter.fromJson(Map<String, dynamic> json) {
    return HadithChapter(
      number: _asInt(
        json['chapterId'] ??
            json['chapterNumber'] ??
            json['chapter'] ??
            json['id'],
      ),
      title: _asString(
        json['chapterNameBengali'] ??
            json['chapterNameEnglish'] ??
            json['chapterName'] ??
            json['title'] ??
            json['name'],
      ),
    );
  }
}

class Hadith {
  const Hadith({
    required this.book,
    required this.chapter,
    required this.number,
    required this.arabic,
    required this.bengali,
    required this.english,
    required this.narrator,
    required this.title,
  });

  final HadithBook book;
  final int chapter;
  final int number;
  final String arabic;
  final String bengali;
  final String english;
  final String narrator;
  final String title;

  String get id => '${book.apiSlug}:$chapter:$number';

  factory Hadith.fromJson(HadithBook book, Map<String, dynamic> json) {
    return Hadith(
      book: book,
      chapter: _asInt(
        json['chapterId'] ?? json['chapterNumber'] ?? json['chapter'],
      ),
      number: _asInt(
        json['hadithId'] ??
            json['hadithNumber'] ??
            json['hadithNo'] ??
            json['id'],
      ),
      arabic: _asString(json['hadithArabic'] ?? json['arabic'] ?? json['ar']),
      bengali: _asString(
        json['hadithBengali'] ??
            json['hadithBangla'] ??
            json['bengali'] ??
            json['bn'],
      ),
      english: _asString(
        json['hadithEnglish'] ?? json['english'] ?? json['en'],
      ),
      narrator: _asString(
        json['narrator'] ?? json['rawi'] ?? json['narratedBy'],
      ),
      title: _asString(
        json['title'] ??
            json['chapterNameBengali'] ??
            json['chapterNameEnglish'] ??
            json['chapterName'],
      ),
    );
  }
}

int _asInt(dynamic value) => int.tryParse('$value') ?? 0;

String _asString(dynamic value) => value?.toString().trim() ?? '';
