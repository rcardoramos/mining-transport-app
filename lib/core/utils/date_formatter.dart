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
    
    // Try standard ISO-8601 parse first
    final parsed = DateTime.tryParse(clean);
    if (parsed != null) return parsed;
    
    // Try parsing dd/MM/yyyy or dd/MM/yyyy HH:mm:ss
    try {
      final parts = clean.split(' ');
      final datePart = parts[0];
      final dateParts = datePart.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        
        int hour = 0;
        int minute = 0;
        int second = 0;
        
        if (parts.length > 1) {
          final timeParts = parts[1].split(':');
          if (timeParts.isNotEmpty) hour = int.parse(timeParts[0]);
          if (timeParts.length > 1) minute = int.parse(timeParts[1]);
          if (timeParts.length > 2) second = int.parse(timeParts[2]);
        }
        
        return DateTime(year, month, day, hour, minute, second);
      }
    } catch (_) {}
    return null;
  }
}
