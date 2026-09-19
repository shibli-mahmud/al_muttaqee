import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/module/tasbih/models/tasbih_models.dart';

void main() {
  group('dhikrPresets', () {
    test('every preset has a unique id', () {
      final ids = dhikrPresets.map((p) => p.id).toSet();
      expect(ids.length, dhikrPresets.length);
    });

    test('the post-prayer tasbih keeps its traditional counts', () {
      expect(presetFor('subhanallah').defaultTarget, 33);
      expect(presetFor('alhamdulillah').defaultTarget, 33);
      expect(presetFor('allahuakbar').defaultTarget, 34);
    });

    test('every preset carries Arabic, Bangla and a transliteration', () {
      for (final preset in dhikrPresets) {
        expect(preset.arabic, isNotEmpty, reason: preset.id);
        expect(preset.bangla, isNotEmpty, reason: preset.id);
        expect(preset.transliteration, isNotEmpty, reason: preset.id);
        expect(preset.meaning, isNotEmpty, reason: preset.id);
        expect(preset.defaultTarget, greaterThan(0), reason: preset.id);
      }
    });

    test('an unknown id falls back rather than throwing', () {
      // A preference written by an older build must not take the screen down.
      expect(presetFor('no-such-dhikr').id, dhikrPresets.first.id);
    });
  });

  group('DhikrDay', () {
    final date = DateTime(2026, 9, 19);

    test('totals across every dhikr counted that day', () {
      final day = DhikrDay(
        date: date,
        counts: const {'subhanallah': 33, 'alhamdulillah': 20},
      );
      expect(day.total, 53);
      expect(day.countOf('subhanallah'), 33);
      expect(day.countOf('durud'), 0);
      expect(day.isEmpty, isFalse);
    });

    test('a day with nothing counted is empty', () {
      expect(DhikrDay.empty(date).total, 0);
      expect(DhikrDay.empty(date).isEmpty, isTrue);
    });
  });

  group('TasbihSummary', () {
    test('starts at zero before anything is read', () {
      const summary = TasbihSummary.empty();
      expect(summary.todayTotal, 0);
      expect(summary.todayRounds, 0);
      expect(summary.streak, 0);
      expect(summary.allTime, 0);
    });
  });
}
