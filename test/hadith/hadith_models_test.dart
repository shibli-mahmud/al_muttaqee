import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';

void main() {
  group('Hadith.fromRow', () {
    test('reads a full row', () {
      final hadith = Hadith.fromRow(const {
        'book': 'bukhari',
        'number': 1,
        'chapter': 1,
        'arabic': 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        'bengali': 'কর্ম নিয়তের উপর নির্ভরশীল।',
        'grade': 'সহিহ',
      });

      expect(hadith.book, 'bukhari');
      expect(hadith.number, 1);
      expect(hadith.grade, 'সহিহ');
      expect(hadith.id, 'bukhari:1');
    });

    test('tolerates the nulls SQLite hands back for empty text', () {
      final hadith = Hadith.fromRow(const {
        'book': 'muslim',
        'number': 7,
        'chapter': 2,
        'arabic': null,
        'bengali': null,
        'grade': null,
      });

      expect(hadith.arabic, '');
      expect(hadith.bengali, '');
      expect(hadith.grade, '');
    });

    test('the id round-trips through the bookmark format', () {
      final hadith = Hadith.fromRow(const {
        'book': 'ibnmajah',
        'number': 4075,
        'chapter': 37,
      });

      final parts = hadith.id.split(':');
      expect(parts, hasLength(2));
      expect(parts.first, 'ibnmajah');
      expect(int.parse(parts.last), 4075);
    });
  });

  group('HadithBook.fromRow', () {
    test('maps the curated flag from its integer column', () {
      final curated = HadithBook.fromRow(const {
        'slug': 'nawawi',
        'name_bn': '৪০ হাদিস — নববি',
        'name_en': 'Forty Hadith of an-Nawawi',
        'name_ar': 'الأربعون النووية',
        'chapter_count': 1,
        'hadith_count': 42,
        'curated': 1,
      });
      final ordinary = HadithBook.fromRow(const {
        'slug': 'bukhari',
        'name_bn': 'সহিহ বুখারি',
        'name_en': 'Sahih al-Bukhari',
        'name_ar': 'صحيح البخاري',
        'chapter_count': 97,
        'hadith_count': 7557,
        'curated': 0,
      });

      expect(curated.curated, isTrue);
      expect(ordinary.curated, isFalse);
      expect(ordinary.hadithCount, 7557);
    });
  });

  group('HadithChapter.fromRow', () {
    test('keeps the Bangla and English titles apart', () {
      final chapter = HadithChapter.fromRow(const {
        'book': 'bukhari',
        'number': 2,
        'name_bn': 'ঈমান',
        'name_en': 'Belief',
        'hadith_count': 51,
      });

      expect(chapter.nameBn, 'ঈমান');
      expect(chapter.nameEn, 'Belief');
      expect(chapter.hadithCount, 51);
    });
  });
}
