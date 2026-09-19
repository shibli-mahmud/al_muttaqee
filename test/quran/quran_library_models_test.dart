import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/module/dua/models/dua_models.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_library_models.dart';

void main() {
  group('AyahRef', () {
    test('is a value type, so it works as a set member', () {
      final refs = <AyahRef>{const AyahRef(18, 32), const AyahRef(18, 32)};
      expect(refs, hasLength(1));
      expect(refs.contains(const AyahRef(18, 32)), isTrue);
      expect(refs.contains(const AyahRef(18, 33)), isFalse);
    });
  });

  group('ReadingPlan', () {
    test('a para a day works out to a khatm in about a month', () {
      const plan = ReadingPlan(type: ReadingPlanType.para, target: 1);
      expect(plan.dailyAyahTarget, ReadingPlan.ayahsPerPara);
      // 6,236 ayahs at ~236 a day.
      expect(plan.daysToKhatm, inInclusiveRange(25, 32));
    });

    test('twenty ayahs a day is about eleven months', () {
      const plan = ReadingPlan(type: ReadingPlanType.ayahs, target: 20);
      final months = (plan.daysToKhatm! / 30).round();
      expect(months, inInclusiveRange(10, 12));
    });

    test('a minutes plan has no ayah target', () {
      const plan = ReadingPlan(type: ReadingPlanType.minutes, target: 10);
      expect(plan.dailyAyahTarget, 0);
      expect(plan.daysToKhatm, isNull);
      expect(plan.isSet, isTrue);
    });

    test('the weekly habit counts as set even with no rate', () {
      const plan = ReadingPlan(type: ReadingPlanType.weekly, target: 1);
      expect(plan.isSet, isTrue);
    });

    test('no plan reports itself as unset', () {
      expect(const ReadingPlan.none().isSet, isFalse);
    });
  });

  group('ReadingDay', () {
    test('reads a row back, rounding seconds to minutes', () {
      final day = ReadingDay.fromRow(const {
        'date': '2026-09-19',
        'ayahs_read': 24,
        'seconds_read': 390,
        'last_surah': 18,
        'last_ayah': 32,
      });

      expect(day.ayahsRead, 24);
      expect(day.minutesRead, 7);
      expect(day.lastSurah, 18);
      expect(day.isEmpty, isFalse);
    });
  });

  group('dua categories', () {
    test('every category has a distinct id', () {
      final ids = duaCategories.map((c) => c.id).toSet();
      expect(ids.length, duaCategories.length);
    });

    test('the contextual windows cover the whole clock', () {
      // Whatever the hour, the screen must open on something.
      for (var hour = 0; hour < 24; hour++) {
        final match = duaCategories.where((c) => c.matchesHour(hour));
        expect(match, isNotEmpty, reason: 'hour $hour has no category');
      }
    });

    test('a window that wraps past midnight still matches', () {
      final sleep = duaCategories.firstWhere((c) => c.id == 'sleep');
      expect(sleep.matchesHour(23), isTrue);
      expect(sleep.matchesHour(2), isTrue);
      expect(sleep.matchesHour(12), isFalse);
    });

    test('contextualCategory always returns something', () {
      expect(contextualCategory(DateTime(2026, 9, 19, 3)).id, 'sleep');
      expect(contextualCategory(DateTime(2026, 9, 19, 7)).id,
          'morning_evening');
      expect(contextualCategory(DateTime(2026, 9, 19, 13)).id, 'food');
    });
  });
}
