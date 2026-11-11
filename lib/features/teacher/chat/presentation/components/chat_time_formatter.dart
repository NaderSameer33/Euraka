import 'package:intl/intl.dart';

class ChatTimeFormatter {
  ChatTimeFormatter._();

  static String formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();

      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      final differenceInDays = today.difference(messageDate).inDays;

      if (differenceInDays == 0) {
        return DateFormat('hh:mm a', 'ar').format(dateTime);
      } else if (differenceInDays == 1) {
        return 'أمس';
      } else if (differenceInDays < 7) {
        return DateFormat('EEEE', 'ar').format(dateTime);
      } else {
        return DateFormat('dd/MM/yyyy', 'ar').format(dateTime);
      }
    } catch (_) {
      return '';
    }
  }

  static String formatMessageTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a', 'ar').format(dateTime);
    } catch (_) {
      return '';
    }
  }
}

