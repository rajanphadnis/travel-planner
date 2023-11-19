import 'dart:math';

import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  if (MediaQuery.of(context).size.width >= 600) {
    return false;
  } else {
    return true;
  }
}

String genRandomString(int length) {
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz123456789';
  Random r = Random();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}

String formatDate(DateTime date) {
  String year = date.year.toString().substring(2);
  String month = date.month.toString();
  String day = date.day.toString();
  return "$month/$day/$year";
}

String formatDateAndTime(DateTime date, String delineator) {
  String year = date.year.toString().substring(2);
  String month = date.month.toString();
  String day = date.day.toString();
  String hour =
      date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString();
  String minute = date.minute.toString().padLeft(2, "0");
  String hourSymbol = date.hour > 12 ? "PM" : "AM";
  String timezone = date.timeZoneOffset.inHours.toString();
  return "$month/$day/$year $delineator $hour:$minute $hourSymbol $timezone";
}
