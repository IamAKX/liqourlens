import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTimeFormatter {
  static String formatDate(Timestamp? date) {
    if (date == null) {
      return '-';
    }
    try {
      return DateFormat('dd MMM yyyy').format(date.toDate());
    } catch (e) {
      return '-';
    }
  }

  static String getTimesAgo(Timestamp? date) {
    if (date == null) {
      return '-';
    }
    try {
      return timeago.format(date.toDate(), locale: 'en_short');
    } catch (e) {
      return '-';
    }
  }
}
