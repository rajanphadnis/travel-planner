import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/stop.dart';

class Trip {
  final String name;
  final DateTime tripStartTime;
  final List<TripStop> stops;

  Trip(this.name, this.tripStartTime, this.stops);

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

    return Trip(
      data["name"],
      tripStartTime.toDate(),
      stops(),
    );
  }
}
