import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/module/prayer_times/data/jamaat_times_repository.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_times_models.dart';

void main() {
  group('dateKey', () {
    test('is zero-padded so it sorts as a string', () {
      expect(dateKey(DateTime(2026, 9, 6)), '2026-09-06');
      expect(dateKey(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('orders correctly across a month boundary', () {
      // The month queries rely on this: they are string ranges, not date
      // comparisons.
      final keys = [
        dateKey(DateTime(2026, 9, 30)),
        dateKey(DateTime(2026, 9, 2)),
        dateKey(DateTime(2026, 10, 1)),
      ]..sort();
      expect(keys, ['2026-09-02', '2026-09-30', '2026-10-01']);
    });

    test('ignores the time of day', () {
      expect(dateKey(DateTime(2026, 9, 6, 23, 59)), '2026-09-06');
      expect(dayOf(DateTime(2026, 9, 6, 23, 59)), DateTime(2026, 9, 6));
    });
  });

  group('trackedPrayers', () {
    test('is the five daily prayers — sunrise is not one of them', () {
      expect(trackedPrayers.length, 5);
      expect(trackedPrayers.contains(PrayerName.sunrise), isFalse);
      expect(trackedPrayers.first, PrayerName.fajr);
      expect(trackedPrayers.last, PrayerName.isha);
    });
  });

  group('DayLog', () {
    final date = DateTime(2026, 9, 6);

    test('counts prayed and qada, but not missed', () {
      final log = DayLog(
        date: date,
        statuses: const {
          PrayerName.fajr: PrayerLogStatus.prayed,
          PrayerName.dhuhr: PrayerLogStatus.qada,
          PrayerName.asr: PrayerLogStatus.missed,
        },
      );

      expect(log.completed, 2);
      expect(log.isLogged(PrayerName.fajr), isTrue);
      expect(log.isLogged(PrayerName.dhuhr), isTrue);
      expect(log.isLogged(PrayerName.asr), isFalse);
      expect(log.isLogged(PrayerName.isha), isFalse);
    });

    test('is complete only when all five are logged', () {
      final partial = DayLog(
        date: date,
        statuses: {
          for (final prayer in trackedPrayers.take(4))
            prayer: PrayerLogStatus.prayed,
        },
      );
      final full = DayLog(
        date: date,
        statuses: {
          for (final prayer in trackedPrayers) prayer: PrayerLogStatus.prayed,
        },
      );

      expect(partial.isComplete, isFalse);
      expect(full.isComplete, isTrue);
    });

    test('an empty day reports nothing logged', () {
      expect(DayLog.empty(date).isEmpty, isTrue);
      expect(DayLog.empty(date).completed, 0);
    });
  });

  group('PrayerLogEntry round trip', () {
    test('survives a write and read through the row shape', () {
      final entry = PrayerLogEntry(
        date: DateTime(2026, 9, 6),
        prayer: PrayerName.asr,
        status: PrayerLogStatus.qada,
        loggedAt: DateTime(2026, 9, 6, 17, 30),
      );

      final restored = PrayerLogEntry.fromRow(entry.toRow());

      expect(restored.date, entry.date);
      expect(restored.prayer, PrayerName.asr);
      expect(restored.status, PrayerLogStatus.qada);
      expect(restored.loggedAt, entry.loggedAt);
      expect(restored.counts, isTrue);
    });
  });

  group('JamaatTime', () {
    test('parses HH:mm', () {
      final parsed = JamaatTime.tryParse('05:00');
      expect(parsed, const JamaatTime(5, 0));
      expect(parsed!.toStorage(), '05:00');
    });

    test('returns null for anything malformed rather than throwing', () {
      // A corrupted preference should degrade to "not set", not take the
      // prayer list down with it.
      expect(JamaatTime.tryParse(null), isNull);
      expect(JamaatTime.tryParse(''), isNull);
      expect(JamaatTime.tryParse('5'), isNull);
      expect(JamaatTime.tryParse('ab:cd'), isNull);
      expect(JamaatTime.tryParse('24:00'), isNull);
      expect(JamaatTime.tryParse('12:60'), isNull);
    });

    test('places itself on a given day', () {
      const time = JamaatTime(16, 30);
      expect(
        time.on(DateTime(2026, 9, 6)),
        DateTime(2026, 9, 6, 16, 30),
      );
    });
  });
}
