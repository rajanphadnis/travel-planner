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

  Future<bool> updateStop(String placeID, String stopName, DateTime startTime,
      DateTime endTime, GeoPoint latLng) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    final TripStop itemToUpdate =
        stops.where((element) => element.placeID == placeID).first;
    final int indexOfUpdatedItem = stops.indexOf(itemToUpdate);
    final TripStop updatedItem = TripStop(
        stopName, placeID, itemToUpdate.index, startTime, endTime, latLng);
    stops.replaceRange(
        indexOfUpdatedItem, indexOfUpdatedItem + 1, [updatedItem]);
    await docRef.update({
      "stops": generateUpdatedStops(),
    });
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

  List<Map<String, dynamic>> generateUpdatedAccomodations() {
    List<Map<String, dynamic>> toReturn = [];
    for (var i = 0; i < accomodation.length; i++) {
      TripAccomodation accom = accomodation[i];
      Map<String, dynamic> toWrite = {
        "name": accom.name,
        "placeID": accom.placeID,
        "type": accom.type.name,
        "startTime": accom.startTime,
        "endTime": accom.endTime,
        "lat_lng": accom.latLng,
        "confirmationSlug": accom.confirmationSlug ?? ""
      };
      toReturn.add(toWrite);
    }
    return toReturn;
  }

  Future<bool> addAccomodation(TripAccomodation newAccomodation) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    accomodation.add(newAccomodation);
    await docRef.update({
      "accomodation": generateUpdatedAccomodations(),
    });
    _stream.add(true);
    completer.complete(true);
    return completer.future;
  }

  Future<bool> updateAccomodation(
      TripAccomodation oldAccomodation,
      TripStop stop,
      Accomodation accomodationType,
      String accomodationName,
      DateTime startTime,
      DateTime endTime,
      GeoPoint latLng,
      String? confirmationSlug) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    final TripAccomodation itemToUpdate =
        accomodation.where((element) => element == oldAccomodation).first;
    final int indexOfUpdatedItem = accomodation.indexOf(itemToUpdate);
    final TripAccomodation updatedItem = TripAccomodation(accomodationName,
        accomodationType, startTime, endTime, latLng, stop.placeID,
        confirmationSlug: confirmationSlug);
    accomodation.replaceRange(
        indexOfUpdatedItem, indexOfUpdatedItem + 1, [updatedItem]);
    await docRef.update({
      "accomodation": generateUpdatedAccomodations(),
    });
    _stream.add(true);
    completer.complete(true);
    return completer.future;
  }

  List<Map<String, dynamic>> generateUpdatedTransportation() {
    List<Map<String, dynamic>> toReturn = [];
    for (var i = 0; i < transportation.length; i++) {
      TripTransportation transport = transportation[i];
      Map<String, dynamic> toWrite = {
        "name": transport.name,
        "startPlaceID": transport.startPlaceID,
        "endPlaceID": transport.endPlaceID,
        "type": transport.type.name,
        "startTime": transport.startTime,
        "endTime": transport.endTime,
        "confirmationSlug": transport.confirmationNumber ?? "",
        "flightTrackingSlug": transport.flightTrackingSlug ?? ""
      };
      toReturn.add(toWrite);
    }
    return toReturn;
  }

  Future<bool> addTransportation(TripTransportation newTransportation) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    transportation.add(newTransportation);
    await docRef.update({
      "transportation": generateUpdatedTransportation(),
    });
    _stream.add(true);
    completer.complete(true);
    return completer.future;
  }

  Future<bool> updateTransportation(
      TripTransportation oldtransportation,
      TripStop startingStop,
      TripStop endingStop,
      Transportation transportationType,
      String transportationName,
      DateTime startTime,
      DateTime endTime,
      GeoPoint latLng,
      String? confirmationSlug,
      String? flightTrackingSlug) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    final TripTransportation itemToUpdate =
        transportation.where((element) => element == oldtransportation).first;
    final int indexOfUpdatedItem = transportation.indexOf(itemToUpdate);
    final TripTransportation updatedItem = TripTransportation(
        transportationName,
        transportationType,
        startTime,
        endTime,
        startingStop.placeID,
        endingStop.placeID,
        flightTrackingSlug: flightTrackingSlug,
        confirmationNumber: confirmationSlug);
    transportation.replaceRange(
        indexOfUpdatedItem, indexOfUpdatedItem + 1, [updatedItem]);
    await docRef.update({
      "transportation": generateUpdatedTransportation(),
    });
    _stream.add(true);
    completer.complete(true);
    return completer.future;
  }
}
