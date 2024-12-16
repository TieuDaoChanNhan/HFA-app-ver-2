import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatetimeChange {
  DatetimeChange._();

  static DateTime getOpendate(DateTime start) {
    return DateTime(start.year, start.month, start.day, 0, 0, 0);
  }

  static DateTime getClosedate(DateTime end) {
    return DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
  }

  static DateTime getDMYTime(DateTime time) {
    return DateTime(time.year, time.month, time.day);
  }

  static int getDuration(DateTime time1, DateTime time2) {
    return getDMYTime(time1).difference(getDMYTime(time2)).inDays;
  }

  static String getDatetimeString(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String getHourString(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  static int getAge(String date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateTime birthDate = dateFormat.parse(date);
    final DateTime now = DateTime.now();
    return now.year - birthDate.year;
  }

  static String timestampToString(Timestamp timestamp) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
  }

  static String timestamptoHHMMDDMMYYYY(Timestamp timestamp) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
    return formatter.format(date);
  }
}
