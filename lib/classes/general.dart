// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';

List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

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

String formatShorterDate(DateTime date) {
  String year = date.year.toString().substring(2);
  String month = date.month.toString();
  String day = date.day.toString();
  return "$month/$day";
}

String formatTime(DateTime date) {
  String hour =
      date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString();
  String minute = date.minute.toString().padLeft(2, "0");
  String hourSymbol = date.hour > 12 ? "PM" : "AM";
  String timezone = date.timeZoneOffset.inHours.toString();
  return "$hour:$minute $hourSymbol";
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

enum SegmentType { flight, hotel, airBNB, roadTrip, rentalCar, 
// SPACE, LAYOVER
 }

extension SegmentTypeProperties on SegmentType {
  String get readableName {
    switch (this) {
      case SegmentType.flight:
        return 'Flight';
      case SegmentType.hotel:
        return 'Hotel';
      case SegmentType.airBNB:
        return 'AirBNB';
      default:
        return "";
    }
  }

  String get nameInputString {
    switch (this) {
      case SegmentType.flight:
        return 'Flight Number:';
      case SegmentType.hotel:
        return 'Hotel Name:';
      case SegmentType.airBNB:
        return 'Address:';
      default:
        return "";
    }
  }

  bool get isLodging {
    switch (this) {
      case SegmentType.hotel:
        return true;
      case SegmentType.airBNB:
        return true;
      default:
        return false;
    }
  }
}

class Segment implements Comparable<Segment> {
  DateTime startTime;
  DateTime endTime;
  String id;
  SegmentType type;

  Segment(
      {required this.startTime,
      required this.endTime,
      required this.id,
      required this.type});

  @override
  int compareTo(Segment other) {
    if (startTime.isBefore(other.startTime)) {
      return -1;
    } else if (startTime.isAfter(other.startTime)) {
      return 1;
    } else {
      return 0;
    }
  }

  String get startTimeFormatted => formatTime(startTime);
  String get endTimeFormatted => formatTime(endTime);
  String get startDateShortFormatted => formatShorterDate(startTime);
  String get endDateShortFormatted => formatShorterDate(endTime);
}
