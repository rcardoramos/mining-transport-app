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
}
