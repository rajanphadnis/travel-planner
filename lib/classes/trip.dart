import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/accomodation.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/transportation.dart';

class Trip {
  final String name;
  final String docID;
  final DateTime tripStartTime;
  final List<TripStop> stops;
  final List<TripTransportation> transportation;
  final List<TripAccomodation> accomodation;

  final StreamController<bool> _stream = StreamController<bool>.broadcast();
  Stream<bool> get stream => _stream.stream;

  Trip(this.name, this.docID, this.tripStartTime, this.stops,
      this.transportation, this.accomodation);

  factory Trip.fromFirestore(QueryDocumentSnapshot<Object?> data) {
    Timestamp tripStartTime = data["startTime"] as Timestamp;
    debugPrint(tripStartTime.toDate().toString());

    List<TripStop> stops() {
      List<TripStop> toReturn = [];
      List<dynamic> stops = data["stops"] as List<dynamic>;
      for (var i = 0; i < stops.length; i++) {
        stops.sort((a, b) => a["index"].compareTo(b["index"]));
        toReturn.add(TripStop.fromFirestore(stops[i]));
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
      data.id,
      tripStartTime.toDate(),
      stops(),
      transportation(),
      accomodation(),
    );
  }

  Future<bool> addStop(String stopName, DateTime startTime, DateTime endTime,
      GeoPoint latLng) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    final String newStopID = genRandomString(10);
    final Map<String, dynamic> newStop = {
      "name": stopName,
      "index": stops.length,
      "startTime": startTime,
      "endTime": endTime,
      "placeID": newStopID,
      "lat_lng": latLng,
    };
    await docRef.update({
      "stops": FieldValue.arrayUnion([newStop]),
    });
    stops.add(TripStop(
        stopName, newStopID, stops.length, startTime, endTime, latLng));
    _stream.add(true);
    completer.complete(true);
    return completer.future;
  }

  List<Map<String, dynamic>> generateUpdatedStops() {
    List<Map<String, dynamic>> toReturn = [];
    for (var i = 0; i < stops.length; i++) {
      TripStop stop = stops[i];
      Map<String, dynamic> toWrite = {
        "name": stop.name,
        "placeID": stop.placeID,
        "index": i,
        "startTime": stop.startTime,
        "endTime": stop.endTime,
        "lat_lng": stop.latLng,
      };
      toReturn.add(toWrite);
    }
    return toReturn;
  }

  Future<bool> updateStopOrder(int oldIndex, int newIndex) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    final Completer<bool> completer = Completer();
    TripStop oldStop = stops.removeAt(oldIndex);
    stops.insert(newIndex, oldStop);

    await docRef.update({
      "stops": generateUpdatedStops(),
    });
    _stream.add(true);
    completer.complete(true);
    return completer.future;
  }
}
