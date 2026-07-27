/// Utility for formatting dates and times in Peru Time (UTC-5).
class PeruDateFormatter {
  PeruDateFormatter._();

  /// Converts any [DateTime] to Peru Time (UTC-5) as a UTC DateTime.
  static DateTime toPeruTime(DateTime dateTime) {
    return dateTime.toUtc().subtract(const Duration(hours: 5));
  }

  /// Formats time as HH:mm in Peru Time.
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final peruTime = toPeruTime(dateTime);
    final hour = peruTime.hour.toString().padLeft(2, '0');
    final minute = peruTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formats time as HH:mm AM/PM in Peru Time.
  static String formatTime12(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final peruTime = toPeruTime(dateTime);
    final hour24 = peruTime.hour;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final amPm = hour24 >= 12 ? 'PM' : 'AM';
    final minute = peruTime.minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$minute $amPm';
  }

  /// Formats date as DD/MM/YYYY in Peru Time.
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '--/--/----';
    final peruTime = toPeruTime(dateTime);
    final day = peruTime.day.toString().padLeft(2, '0');
    final month = peruTime.month.toString().padLeft(2, '0');
    final year = peruTime.year.toString();
    return '$day/$month/$year';
  }

  /// Parses a date string in various formats (ISO-8601, dd/MM/yyyy).
  static DateTime? parseFlexible(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    final clean = dateStr.trim();

    int? year;
    int? month;
    int? day;
    int hour = 0;
    int minute = 0;
    int second = 0;

    // 1. Check if it matches ISO-8601: yyyy-MM-dd ...
    final isoRegex = RegExp(r'^(\d{4})[-/](\d{2})[-/](\d{2})(?:[ T](\d{2}):(\d{2}):(\d{2}))?');
    final isoMatch = isoRegex.firstMatch(clean);
    if (isoMatch != null) {
      year = int.parse(isoMatch.group(1)!);
      month = int.parse(isoMatch.group(2)!);
      day = int.parse(isoMatch.group(3)!);
      if (isoMatch.group(4) != null) hour = int.parse(isoMatch.group(4)!);
      if (isoMatch.group(5) != null) minute = int.parse(isoMatch.group(5)!);
      if (isoMatch.group(6) != null) second = int.parse(isoMatch.group(6)!);
    } else {
      // 2. Check if it matches Latin: dd/MM/yyyy ...
      final latinRegex = RegExp(r'^(\d{2})[-/](\d{2})[-/](\d{4})(?:[ T](\d{2}):(\d{2}):(\d{2}))?');
      final latinMatch = latinRegex.firstMatch(clean);
      if (latinMatch != null) {
        day = int.parse(latinMatch.group(1)!);
        month = int.parse(latinMatch.group(2)!);
        year = int.parse(latinMatch.group(3)!);
        if (latinMatch.group(4) != null) hour = int.parse(latinMatch.group(4)!);
        if (latinMatch.group(5) != null) minute = int.parse(latinMatch.group(5)!);
        if (latinMatch.group(6) != null) second = int.parse(latinMatch.group(6)!);
      }
    }

    if (year == null || month == null || day == null) {
      // Fallback to standard DateTime.tryParse
      final fallback = DateTime.tryParse(clean);
      if (fallback == null) return null;
      // Convert standard DateTime to a UTC DateTime representing the same Peru local time
      final local = fallback.toLocal();
      return DateTime.utc(
        local.year,
        local.month,
        local.day,
        local.hour,
        local.minute,
        local.second,
        local.millisecond,
        local.microsecond,
      ).add(const Duration(hours: 5));
    }

    // Construct a UTC DateTime corresponding to the Peru local time fields,
    // then add 5 hours to represent the actual UTC instant.
    return DateTime.utc(year, month, day, hour, minute, second).add(const Duration(hours: 5));
  }
}
