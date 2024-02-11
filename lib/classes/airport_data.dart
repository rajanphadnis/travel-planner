// ignore_for_file: non_constant_identifier_names, unnecessary_string_escapes

import 'dart:convert';

import 'package:flutter/widgets.dart';

class Airport {
  final String ICAO;
  final String? IATA;
  final String name;
  final String? city;
  final String? state;
  final String country;
  final int elevation;
  final double latitude;
  final double longitude;
  final String timeZone;

  Airport({
    required this.ICAO,
    required this.IATA,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.elevation,
    required this.latitude,
    required this.longitude,
    required this.timeZone,
  });

  bool isAirport(String searchCode) {
    if (searchCode == ICAO || searchCode == IATA) {
      return true;
    } else {
      return false;
    }
  }
}

class AirportData {
  static final AirportData _instance = AirportData._internal();

  factory AirportData() {
    return _instance;
  }

  AirportData._internal();

  final Map<String, Airport> airports = {};

  void init(String data) {
    final jsonDATA = jsonDecode(data);
    jsonDATA.forEach((code, data) {
      Airport toAdd = Airport(
        ICAO: data["icao"],
        IATA: data["iata"],
        name: data["name"],
        city: data["city"],
        state: data["state"],
        country: data["country"],
        elevation: data["elevation"],
        latitude: double.parse(data["lat"].toString()),
        longitude: double.parse(data["lon"].toString()),
        timeZone: data["tz"],
      );
      airports[code] = toAdd;
    });
    debugPrint("done importing");
  }

  Airport airportSearch(String iataSearch) {
    Airport found;
    try {
      found = airports.entries
          .firstWhere((element) => element.value.IATA == iataSearch)
          .value;
    } catch (e) {
      found = Airport(
          ICAO: "NONE",
          IATA: "NAN",
          name: "NONE",
          city: "NONE",
          state: "NONE",
          country: "NONE",
          elevation: 0,
          latitude: 0,
          longitude: 0,
          timeZone: "America\/Los_Angeles");
    }
    // String toReturn = found.city ?? found.name;
    return found;
  }
}
