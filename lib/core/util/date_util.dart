import 'package:alerta_criminal/core/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> openDatePicker(BuildContext context) async {
  final currentDate = DateTime.now();
  final firstDate = DateTime(currentDate.year, currentDate.month, 1);
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: firstDate,
    lastDate: currentDate,
  );
  return pickedDate;
}

Future<TimeOfDay?> openTimePicker(BuildContext context) async {
  final currentDate = DateTime.now();
  final currentTime = TimeOfDay(hour: currentDate.hour, minute: currentDate.minute);
  final pickedTime = await showTimePicker(context: context, initialTime: currentTime);
  return pickedTime;
}

String formatTime(TimeOfDay time) => "${time.hour}:${time.minute < 10 ? "0" : ""}${time.minute}";

extension DateParsing on DateTime {
  String formatToDefaultPattern(BuildContext context) => DateFormat("dd/MM/yyyy").format(this);

  String getDifferenceFromNow(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 60) {
      return getStrings(context).diffTimeMinuteSuffix(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return getStrings(context).diffTimeHourSuffix(difference.inHours);
    } else if (difference.inDays < 7) {
      return getStrings(context).diffTimeDaySuffix(difference.inDays);
    } else if (difference.inDays < 30) {
      return getStrings(context).diffTimeWeekSuffix((difference.inDays / 7).floor());
    } else if (difference.inDays < 365) {
      return getStrings(context).diffTimeMonthSuffix((difference.inDays / 30).floor());
    } else {
      return getStrings(context).diffTimeYearSuffix((difference.inDays / 365).floor());
    }
  }
}

