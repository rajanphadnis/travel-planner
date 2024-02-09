import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
    background: Colors.black87,
  ),
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class AppTextStyle {
  static const String fontfamily = 'Outfit';
  static const String receiptFontfamily = 'Readex Pro';
  static const Color fontColor = Colors.white;
  static const Color reverseFontColor = Colors.black;

  static const TextStyle itineraryDateNum = TextStyle(
    fontFamily: fontfamily,
    color: fontColor,
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );
  static const TextStyle itineraryDate = TextStyle(
    fontFamily: fontfamily,
    color: fontColor,
    fontSize: 20,
    fontWeight: FontWeight.w100,
  );
  static const TextStyle itineraryAirportCode = TextStyle(
    fontFamily: fontfamily,
    color: reverseFontColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle itineraryDepartArriveTime = TextStyle(
    fontFamily: fontfamily,
    color: reverseFontColor,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle itineraryCityName = TextStyle(
    fontFamily: fontfamily,
    color: reverseFontColor,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle itineraryFlightNumber = TextStyle(
    fontFamily: fontfamily,
    color: reverseFontColor,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle itineraryLodgingName = TextStyle(
    fontFamily: fontfamily,
    color: reverseFontColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle itineraryLodgingDate = TextStyle(
    fontFamily: fontfamily,
    color: reverseFontColor,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle itineraryLayoverTitle = TextStyle(
    fontFamily: fontfamily,
    color: fontColor,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle itineraryLayoverTime = TextStyle(
    fontFamily: fontfamily,
    color: fontColor,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}
