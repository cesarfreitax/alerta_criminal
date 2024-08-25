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
String formatTime(TimeOfDay time) => "${time.hour}:${time.minute}";

