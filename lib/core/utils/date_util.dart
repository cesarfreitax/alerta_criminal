import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:flutter/material.dart';

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

String formatDate(DateTime date) => date.toString().split(" ").first;
String formatDateToBrPattern(DateTime date) => "${date.day}/${date.month}/${date.year}";
String formatTime(TimeOfDay time) => "${time.hour}:${time.minute < 10 ? "0" : ""}${time.minute}";
String formatDayText(DateTime date, BuildContext context) {
  final today = isCurrentDay(date);
  final yesterday = isYesterday(date);
  return today ? getStrings(context).today : yesterday ? getStrings(context).yesterday : formatDate(date);
}
bool isCurrentDay(DateTime date) => formatDateToBrPattern(date) == formatDateToBrPattern(DateTime.now());
bool isYesterday(DateTime date) {
  final currentDate = DateTime.now();
  final yesterdayDate = DateTime(currentDate.year, currentDate.month, currentDate.day - 1);
  final isYesterday = formatDateToBrPattern(date) == formatDateToBrPattern(yesterdayDate);
  return isYesterday;
}
bool isTodayOrYesterday(String formattedDate, BuildContext context) => formattedDate == getStrings(context).today || formattedDate == getStrings(context).yesterday;

