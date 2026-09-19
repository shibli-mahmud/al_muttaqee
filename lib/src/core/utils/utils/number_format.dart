import 'dart:ui';

import 'package:al_muttaqee/l10n/l10n.dart';

/// Every number the user reads goes through this file.
///
/// Under `bn` the app renders Bengali numerals (০১২৩৪৫৬৭৮৯) for times,
/// counters, ayah numbers, dates, currency, percentages and degrees — not just
/// for decorative figures. Under `en` everything falls back to Western digits,
/// so the same call sites work in both locales.
///
/// Grouping follows the Indian lakh/crore system, because that is how the
/// audience reads money: ২২,৬০,০০০, never 2,260,000.
const List<String> _bengaliDigits = [
  '০',
  '১',
  '২',
  '৩',
  '৪',
  '৫',
  '৬',
  '৭',
  '৮',
  '৯',
];

Locale get _currentLocale => L10n.selectedLocale;

/// Rewrites every ASCII digit in [text] as a Bengali numeral when [locale] is
/// Bangla. Anything that is not a digit passes through untouched, so this is
/// safe to run over an already-formatted string like `4:12` or `24 Rabi`.
String localizeDigits(String text, [Locale? locale]) {
  if (!L10n.isBangla(locale ?? _currentLocale)) return text;

  final buffer = StringBuffer();
  for (final unit in text.codeUnits) {
    if (unit >= 0x30 && unit <= 0x39) {
      buffer.write(_bengaliDigits[unit - 0x30]);
    } else {
      buffer.writeCharCode(unit);
    }
  }
  return buffer.toString();
}

/// Formats an integer in the current (or given) locale's digits.
///
/// This is the promoted form of the helper that used to live in the Quran
/// module; it keeps the same name and signature so those call sites still
/// compile, but [locale] is now optional.
String formatNumberWithLocale(int value, [Locale? locale]) =>
    localizeDigits(value.toString(), locale);

/// Groups an integer the Indian way — the last three digits, then pairs —
/// and localizes the digits. `2260000` becomes `২২,৬০,০০০`.
String formatGrouped(num value, [Locale? locale]) {
  final negative = value < 0;
  final digits = value.abs().round().toString();

  String grouped;
  if (digits.length <= 3) {
    grouped = digits;
  } else {
    final tail = digits.substring(digits.length - 3);
    var head = digits.substring(0, digits.length - 3);
    final parts = <String>[];
    while (head.length > 2) {
      parts.insert(0, head.substring(head.length - 2));
      head = head.substring(0, head.length - 2);
    }
    if (head.isNotEmpty) parts.insert(0, head);
    grouped = '${parts.join(',')},$tail';
  }

  return localizeDigits('${negative ? '-' : ''}$grouped', locale);
}

/// Currency as the audience writes it: the taka sign trails the amount after a
/// space — `৫৬,৫০০ ৳`.
String formatTaka(num value, [Locale? locale]) => '${formatGrouped(value, locale)} ৳';

/// A negative amount, for zakat deductions. The minus is a real minus sign
/// (U+2212) rather than a hyphen so it lines up with the digits.
String formatTakaNegative(num value, [Locale? locale]) =>
    '−${formatTaka(value.abs(), locale)}';

/// A clock time in 12-hour form without the am/pm marker, which the designs
/// carry in the surrounding Bangla copy instead (`ওয়াক্ত শুরু বিকাল ৪:১২`).
String formatClock(DateTime time, [Locale? locale]) {
  final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  return localizeDigits('$hour12:$minute', locale);
}

/// The Bangla word for the part of day a time falls in. Used to build the
/// `ওয়াক্ত শুরু বিকাল ৪:১২` sub-line, where the period word does the work an
/// am/pm marker would do in English.
String banglaDayPart(DateTime time) {
  final h = time.hour;
  if (h < 4) return 'রাত';
  if (h < 6) return 'ভোর';
  if (h < 12) return 'সকাল';
  if (h < 15) return 'দুপুর';
  if (h < 18) return 'বিকাল';
  if (h < 19) return 'সন্ধ্যা';
  return 'রাত';
}

/// A clock time prefixed with its part of day: `বিকাল ৪:১২`.
String formatClockWithPeriod(DateTime time, [Locale? locale]) {
  final resolved = locale ?? _currentLocale;
  if (!L10n.isBangla(resolved)) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
  }
  return '${banglaDayPart(time)} ${formatClock(time, resolved)}';
}

/// `১:২৪:০৬` — the running countdown in the নামাজ hero. Hours are dropped
/// once there is less than an hour left, so the figure never leads with a
/// meaningless zero.
String formatCountdown(Duration d, [Locale? locale]) {
  final total = d.isNegative ? Duration.zero : d;
  final hours = total.inHours;
  final minutes = total.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = total.inSeconds.remainder(60).toString().padLeft(2, '0');
  final raw = hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  return localizeDigits(raw, locale);
}

/// `১ ঘণ্টা ২৪ মিনিট বাকি` — the countdown pill on হোম, which reads as a
/// sentence rather than a clock because it is glanced at, not watched.
String formatRemainingWords(Duration d, [Locale? locale]) {
  final resolved = locale ?? _currentLocale;
  final total = d.isNegative ? Duration.zero : d;
  final hours = total.inHours;
  final minutes = total.inMinutes.remainder(60);

  if (!L10n.isBangla(resolved)) {
    if (hours > 0) return '$hours hr $minutes min left';
    return '$minutes min left';
  }

  if (hours > 0) {
    return '${localizeDigits('$hours', resolved)} ঘণ্টা '
        '${localizeDigits('$minutes', resolved)} মিনিট বাকি';
  }
  if (minutes > 0) {
    return '${localizeDigits('$minutes', resolved)} মিনিট বাকি';
  }
  return 'এখনই ওয়াক্ত';
}

/// `প্রায় ৪ মিনিট` style approximation used by the reading plan.
String formatMinutes(int minutes, [Locale? locale]) {
  final resolved = locale ?? _currentLocale;
  if (!L10n.isBangla(resolved)) return '$minutes min';
  return '${localizeDigits('$minutes', resolved)} মিনিট';
}

/// A percentage with localized digits: `৬০%`.
String formatPercent(num fraction, [Locale? locale]) =>
    '${localizeDigits((fraction * 100).round().toString(), locale)}%';

/// `১২ / ২০` — a progress pair, as used by the tracker and the reading plan.
String formatRatio(int done, int total, [Locale? locale]) =>
    '${formatNumberWithLocale(done, locale)} / ${formatNumberWithLocale(total, locale)}';

const List<String> _banglaMonths = [
  'জানুয়ারি',
  'ফেব্রুয়ারি',
  'মার্চ',
  'এপ্রিল',
  'মে',
  'জুন',
  'জুলাই',
  'আগস্ট',
  'সেপ্টেম্বর',
  'অক্টোবর',
  'নভেম্বর',
  'ডিসেম্বর',
];

const List<String> _englishMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// The Gregorian month name in the active locale.
String monthName(int month, [Locale? locale]) {
  final index = (month - 1).clamp(0, 11);
  return L10n.isBangla(locale ?? _currentLocale)
      ? _banglaMonths[index]
      : _englishMonths[index];
}

/// `৬ সেপ্টেম্বর` — the short date on the home date card.
String formatDayMonth(DateTime date, [Locale? locale]) =>
    '${formatNumberWithLocale(date.day, locale)} ${monthName(date.month, locale)}';

/// Weekday names, Bangla week starting Sunday (রবিবার) as the calendar does.
const List<String> _banglaWeekdays = [
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার',
  'শনিবার',
  'রবিবার',
];

const List<String> _englishWeekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// [DateTime.weekday] is 1 (Monday) through 7 (Sunday), which is the order
/// both tables above use.
String weekdayName(DateTime date, [Locale? locale]) {
  final index = (date.weekday - 1).clamp(0, 6);
  return L10n.isBangla(locale ?? _currentLocale)
      ? _banglaWeekdays[index]
      : _englishWeekdays[index];
}
