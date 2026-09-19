import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/core/utils/utils/number_format.dart';

const bn = Locale('bn');
const en = Locale('en');

void main() {
  group('localizeDigits', () {
    test('rewrites ASCII digits as Bengali numerals under bn', () {
      expect(localizeDigits('4:12', bn), '৪:১২');
      expect(localizeDigits('2026', bn), '২০২৬');
    });

    test('leaves everything that is not a digit alone', () {
      expect(localizeDigits('জামাত ৪:৩০', bn), 'জামাত ৪:৩০');
      expect(localizeDigits('18:32', bn), '১৮:৩২');
    });

    test('falls back to Western digits under en', () {
      expect(localizeDigits('4:12', en), '4:12');
      expect(formatNumberWithLocale(2026, en), '2026');
    });
  });

  group('formatGrouped', () {
    test('groups the Indian way — last three, then pairs', () {
      expect(formatGrouped(2260000, en), '22,60,000');
      expect(formatGrouped(2260000, bn), '২২,৬০,০০০');
    });

    test('leaves three digits or fewer ungrouped', () {
      expect(formatGrouped(999, en), '999');
      expect(formatGrouped(0, en), '0');
    });

    test('groups a four-digit value at the thousand', () {
      expect(formatGrouped(1234, en), '1,234');
    });

    test('carries a negative sign', () {
      expect(formatGrouped(-56500, en), '-56,500');
    });
  });

  group('currency', () {
    test('puts the taka sign after the amount, with a space', () {
      expect(formatTaka(56500, bn), '৫৬,৫০০ ৳');
    });

    test('renders a deduction with a real minus sign', () {
      expect(formatTakaNegative(-1200, en), '−1,200 ৳');
    });
  });

  group('formatCountdown', () {
    test('includes hours only when there is an hour to show', () {
      expect(
        formatCountdown(const Duration(hours: 1, minutes: 24, seconds: 6), en),
        '1:24:06',
      );
      expect(
        formatCountdown(const Duration(minutes: 4, seconds: 9), en),
        '04:09',
      );
    });

    test('clamps a negative duration to zero rather than showing a sign', () {
      expect(formatCountdown(const Duration(seconds: -30), en), '00:00');
    });

    test('localizes the digits', () {
      expect(
        formatCountdown(const Duration(hours: 1, minutes: 24, seconds: 6), bn),
        '১:২৪:০৬',
      );
    });
  });

  group('formatRemainingWords', () {
    test('reads as a sentence, not a clock', () {
      expect(
        formatRemainingWords(const Duration(hours: 1, minutes: 24), bn),
        '১ ঘণ্টা ২৪ মিনিট বাকি',
      );
      expect(
        formatRemainingWords(const Duration(minutes: 24), bn),
        '২৪ মিনিট বাকি',
      );
    });

    test('says the window is open rather than "0 minutes left"', () {
      expect(formatRemainingWords(Duration.zero, bn), 'এখনই ওয়াক্ত');
    });
  });

  group('clock', () {
    test('formats 12-hour time without an am/pm marker', () {
      expect(formatClock(DateTime(2026, 9, 6, 16, 12), en), '4:12');
      expect(formatClock(DateTime(2026, 9, 6, 16, 12), bn), '৪:১২');
    });

    test('renders midnight and noon as 12, not 0', () {
      expect(formatClock(DateTime(2026, 9, 6, 0, 5), en), '12:05');
      expect(formatClock(DateTime(2026, 9, 6, 12, 5), en), '12:05');
    });

    test('prefixes the Bangla part of day', () {
      expect(
        formatClockWithPeriod(DateTime(2026, 9, 6, 16, 12), bn),
        'বিকাল ৪:১২',
      );
      expect(
        formatClockWithPeriod(DateTime(2026, 9, 6, 4, 38), bn),
        'ভোর ৪:৩৮',
      );
    });
  });

  group('dates', () {
    test('names the Gregorian month in the active locale', () {
      expect(formatDayMonth(DateTime(2026, 9, 6), bn), '৬ সেপ্টেম্বর');
      expect(formatDayMonth(DateTime(2026, 9, 6), en), '6 September');
    });

    test('maps DateTime.weekday onto the right day name', () {
      // 6 September 2026 is a Sunday.
      expect(weekdayName(DateTime(2026, 9, 6), bn), 'রবিবার');
      expect(weekdayName(DateTime(2026, 9, 7), bn), 'সোমবার');
    });
  });

  test('formatPercent rounds and localizes', () {
    expect(formatPercent(0.604, bn), '৬০%');
    expect(formatPercent(0.604, en), '60%');
  });

  test('formatRatio reads as done over total', () {
    expect(formatRatio(142, 150, bn), '১৪২ / ১৫০');
  });
}
