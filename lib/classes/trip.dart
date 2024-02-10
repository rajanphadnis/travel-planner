import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/ground_transport.dart';
import 'package:travel_planner/classes/lodging.dart';

class Trip {
  String name;
  final String docID;
  DateTime tripStartTime;
  List<Segment> segments;

  final StreamController<Trip> _stream = StreamController<Trip>.broadcast();
  Stream<Trip> get stream => _stream.stream;
  String get formattedStartDate => formatDate(tripStartTime);

  Trip(this.name, this.docID, this.tripStartTime, this.segments);

  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  factory Trip.fromFirestore(dynamic data) {
    DateTime tripStartTime = (data["startTime"] as Timestamp).toDate();
    List<Segment> segmentList = [];
    List<Segment> sortedSegmentList = [];

    List<dynamic> segments = data["trip"] as List<dynamic>;
    for (var segment in segments) {
      switch (segment["type"]) {
        case "FLIGHT":
          segmentList.add(
            Flight(
              startAirport: segment["startAirport"],
              endAirport: segment["endAirport"],
              flightNumber: segment["flightNumber"],
              id: segment["id"],
              type: SegmentType.flight,
              startTime: (segment["startTime"] as Timestamp).toDate(),
              endTime: (segment["endTime"] as Timestamp).toDate(),
            ),
          );
          break;
        case "HOTEL":
          segmentList.add(
            Lodging(
              name: segment["name"],
              type: SegmentType.hotel,
              startTime: (segment["startTime"] as Timestamp).toDate(),
              endTime: (segment["endTime"] as Timestamp).toDate(),
              id: segment["id"],
            ),
          );
          break;
        case "AIRBNB":
          segmentList.add(
            Lodging(
              name: segment["name"],
              type: SegmentType.airBNB,
              startTime: (segment["startTime"] as Timestamp).toDate(),
              endTime: (segment["endTime"] as Timestamp).toDate(),
              id: segment["id"],
            ),
          );
          break;
        case "ROADTRIP":
          segmentList.add(
            GroundTransport(
              name: segment["name"],
              start: segment["start"],
              end: segment["end"],
              type: SegmentType.roadTrip,
              startTime: (segment["startTime"] as Timestamp).toDate(),
              endTime: (segment["endTime"] as Timestamp).toDate(),
              id: segment["id"],
            ),
          );
          break;
        case "RENTAL_CAR":
          segmentList.add(
            GroundTransport(
              name: segment["name"],
              start: segment["start"],
              end: segment["end"],
              type: SegmentType.rentalCar,
              startTime: (segment["startTime"] as Timestamp).toDate(),
              endTime: (segment["endTime"] as Timestamp).toDate(),
              id: segment["id"],
            ),
          );
          break;
        case "BUS":
          segmentList.add(
            GroundTransport(
              name: segment["name"],
              start: segment["start"],
              end: segment["end"],
              type: SegmentType.bus,
              startTime: (segment["startTime"] as Timestamp).toDate(),
              endTime: (segment["endTime"] as Timestamp).toDate(),
              id: segment["id"],
            ),
          );
          break;
        default:
          debugPrint("something went wrong");
      }
    }
    sortedSegmentList = segmentList;
    sortedSegmentList.sort(
      (a, b) => a.compareTo(b),
    );
    return Trip(data["name"], data.id, tripStartTime, sortedSegmentList);
  }

  Future<bool> updateSegment(Segment toAdd) {
    Map<String, dynamic> newSegment = {};
    Map<String, dynamic> oldSegment = {};
    final batch = _db.batch();
    var ref = _db.collection('users/$_uid/activeTrips').doc(docID);

    switch (toAdd.type) {
      case SegmentType.flight:
        newSegment = (toAdd as Flight).firebaseOutput;
        oldSegment =
            (segments.firstWhere((seg) => seg.id == toAdd.id) as Flight)
                .firebaseOutput;
        break;
      case SegmentType.hotel:
        continue lodgingCases;
      lodgingCases:
      case SegmentType.airBNB:
        newSegment = (toAdd as Lodging).firebaseOutput;
        oldSegment =
            (segments.firstWhere((seg) => seg.id == toAdd.id) as Lodging)
                .firebaseOutput;
        break;
      case SegmentType.rentalCar:
        continue groundTransportCases;
      case SegmentType.roadTrip:
        continue groundTransportCases;
      groundTransportCases:
      case SegmentType.bus:
        newSegment = (toAdd as GroundTransport).firebaseOutput;
        oldSegment = (segments.firstWhere((seg) => seg.id == toAdd.id)
                as GroundTransport)
            .firebaseOutput;

        break;
      default:
        debugPrint("failed to update");
    }
    batch.update(ref, {
      "trip": FieldValue.arrayUnion([newSegment])
    });
    batch.update(ref, {
      "trip": FieldValue.arrayRemove([oldSegment])
    });

    return batch.commit().then((value) {
      _stream.add(this);
      return true;
    });
  }

  Future<bool> createSegment(Segment toAdd) {
    Map<String, dynamic> newSegment = {};
    var ref = _db.collection('users/$_uid/activeTrips').doc(docID);

    switch (toAdd.type) {
      case SegmentType.flight:
        newSegment = (toAdd as Flight).firebaseOutput;
        break;
      case SegmentType.hotel: // empty on purpose
      case SegmentType.airBNB:
        newSegment = (toAdd as Lodging).firebaseOutput;
        break;
      case SegmentType.rentalCar:
      case SegmentType.roadTrip:
      case SegmentType.bus:
        newSegment = (toAdd as GroundTransport).firebaseOutput;
        break;
      default:
        debugPrint("failed to update");
    }

    return ref.update({
      "trip": FieldValue.arrayUnion([newSegment])
    }).then((value) {
      _stream.add(this);
      return true;
    });
  }

  Future<bool> deleteSegment(String idToDelete, SegmentType type) {
    Map<String, dynamic> foundSegment = {};
    var ref = _db.collection('users/$_uid/activeTrips').doc(docID);

    switch (type) {
      case SegmentType.flight:
        foundSegment = (segments
                .firstWhere((segment) => segment.id == idToDelete) as Flight)
            .firebaseOutput;
        break;
      case SegmentType.hotel: // empty on purpose
      case SegmentType.airBNB:
        foundSegment = (segments
                .firstWhere((segment) => segment.id == idToDelete) as Lodging)
            .firebaseOutput;
        break;
      case SegmentType.rentalCar:
      case SegmentType.roadTrip:
      case SegmentType.bus:
        foundSegment = (segments
                .firstWhere((segment) => segment.id == idToDelete) as GroundTransport)
            .firebaseOutput;
        break;
      default:
        debugPrint("failed to update");
    }

    return ref.update({
      "trip": FieldValue.arrayRemove([foundSegment])
    }).then((value) {
      _stream.add(this);
      return true;
    });
  }

  Future<bool> deleteTrip() async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    await docRef.delete();
    _stream.add(this);
    completer.complete(true);
    return completer.future;
  }

  Future<bool> updateTrip(String newName, DateTime newStartDate) async {
    final Completer<bool> completer = Completer();
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final DocumentReference<Map<String, dynamic>> docRef =
        db.collection("users/${user.uid}/activeTrips").doc(docID);
    await docRef.update({
      "name": newName,
      "startTime": newStartDate,
    });
    name = newName;
    tripStartTime = newStartDate;
    _stream.add(this);
    completer.complete(true);
    return completer.future;
  }

  void triggerUpdate() {
    _stream.add(this);
  }
}
