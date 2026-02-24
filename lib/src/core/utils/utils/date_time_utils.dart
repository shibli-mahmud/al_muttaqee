import 'dart:developer';
import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Parse ISO 8601 date string to DateTime string
  static String parseDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final parsed = DateTime.tryParse(date);
      return parsed?.toIso8601String() ?? '-';
    } catch (e) {
      log('Error parsing date: $e');
      return '-';
    }
  }

  /// Parse time string (HH:mm or H:mm format) to time string
  static String parseTime(String? time) {
    if (time == null || time.isEmpty) return '-';

    try {
      final parts = time.trim().split(':');

      if (parts.length != 2) {
        throw const FormatException('Invalid time format');
      }

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw const FormatException('Invalid time range');
      }

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      log('Error parsing time: $e');
      return '-';
    }
  }

  /// Parse ISO 8601 datetime string to datetime string
  static String parseDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    try {
      final parsed = DateTime.tryParse(dateTime);
      return parsed?.toIso8601String() ?? '-';
    } catch (e) {
      log('Error parsing datetime: $e');
      return '-';
    }
  }

  /// Convert DateTime to ISO 8601 string, returns current time if null
  static String dateToString(DateTime? date) {
    return date?.toIso8601String() ?? DateTime.now().toIso8601String();
  }

  /// Convert DateTime to time string (HH:mm format)
  static String timeToString(DateTime? time) {
    if (time == null) return '00:00';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Convert DateTime to ISO 8601 string
  static String dateTimeToString(DateTime? dateTime) {
    return dateTime?.toIso8601String() ?? DateTime.now().toIso8601String();
  }

  /// Get current DateTime as ISO string
  static String get now => DateTime.now().toIso8601String();

  /// Format time string to AM/PM format (e.g., "14:30" -> "2:30 PM")
  static String formatTimeAMPM(String? time) {
    if (time == null || time.isEmpty) return '-';

    try {
      final DateTime dateTime = DateFormat.Hm().parse(time);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      log('Error formatting time to AM/PM: $e');
      return '-';
    }
  }

  /// Format date string with custom format
  /// Example: formatDate('MMM dd, yyyy', '2024-12-08') -> "Dec 08, 2024"
  static String formatDate(String format, String? date) {
    if (date == null || date.isEmpty) return '-';

    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat(format).format(dateTime);
    } catch (e) {
      log('Error formatting date: $e');
      return '-';
    }
  }

  /// Format DateTime with custom format
  static String formatDateTime(String format, DateTime? dateTime) {
    if (dateTime == null) return '-';

    try {
      return DateFormat(format).format(dateTime);
    } catch (e) {
      log('Error formatting datetime: $e');
      return '-';
    }
  }

  /// Get GMT offset string (e.g., "GMT+6" or "GMT-5")
  static String gmt() {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours.abs();
    final minutes = (offset.inMinutes.abs() % 60);

    final sign = offset.isNegative ? '-' : '+';

    if (minutes == 0) {
      return 'GMT$sign$hours';
    }
    return 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
  }

  /// Get time zone name
  static String timeZoneName() {
    return DateTime.now().timeZoneName;
  }

  /// Check if a date is today
  static String isToday(DateTime? date) {
    if (date == null) return 'false';
    final now = DateTime.now();
    final result = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    return result.toString();
  }

  /// Check if a date is in the past
  static String isPast(DateTime? date) {
    if (date == null) return 'false';
    return date.isBefore(DateTime.now()).toString();
  }

  /// Check if a date is in the future
  static String isFuture(DateTime? date) {
    if (date == null) return 'false';
    return date.isAfter(DateTime.now()).toString();
  }

  /// Get difference between two dates in days
  static String daysBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return '0';
    final difference = to.difference(from);
    return difference.inDays.toString();
  }

  /// Format duration in human-readable format
  static String formatDuration(Duration? duration) {
    if (duration == null) return '-';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}