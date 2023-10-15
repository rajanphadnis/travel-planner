import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/accomodation.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/transportation.dart';

class Trip {
  final String name;
  final DateTime tripStartTime;
  final List<TripStop> stops;
  final List<TripTransportation> transportation;
  final List<TripAccomodation> accomodation;

  Trip(this.name, this.tripStartTime, this.stops, this.transportation,
      this.accomodation);

  factory Trip.fromFirestore(QueryDocumentSnapshot<Object?> data) {
    Timestamp tripStartTime = data["startTime"] as Timestamp;
    debugPrint(tripStartTime.toDate().toString());

    List<TripStop> stops() {
      List<TripStop> toReturn = [];
      for (var i = 0; i < data["stops"].length; i++) {
        toReturn.add(TripStop.fromFirestore(data["stops"][i]));
      }
      return toReturn;
    }

    List<TripTransportation> transportation() {
      List<TripTransportation> toReturn = [];
      for (var i = 0; i < data["transportation"].length; i++) {
        toReturn
            .add(TripTransportation.fromFirestore(data["transportation"][i]));
      }
      return toReturn;
    }

    List<TripAccomodation> accomodation() {
      List<TripAccomodation> toReturn = [];
      for (var i = 0; i < data["accomodation"].length; i++) {
        toReturn.add(TripAccomodation.fromFirestore(data["accomodation"][i]));
      }
      return toReturn;
    }

    return Trip(
      data["name"],
      tripStartTime.toDate(),
      stops(),
      transportation(),
      accomodation(),
    );
  }
}
