import 'package:intl/intl.dart';

class DateHelper {
  static final DateFormat displayFormat = DateFormat('dd MMM yyyy');
  static final DateFormat displayFormatWithTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat apiFormat = DateFormat('yyyy-MM-dd');
  
  static String formatDate(DateTime date) {
    return displayFormat.format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return displayFormatWithTime.format(date);
  }
  
  static String formatForApi(DateTime date) {
    return apiFormat.format(date);
  }
  
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }
  
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }
  
  static String getRelativeDate(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isYesterday(date)) return 'Yesterday';
    return formatDate(date);
  }
}
