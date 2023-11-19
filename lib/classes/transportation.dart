import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_planner/classes/general.dart';

class TripTransportation {
  final String name;
  final Transportation type;
  final String? flightTrackingSlug;
  final String? confirmationNumber;
  final DateTime startTime;
  final DateTime endTime;
  final String startPlaceID;
  final String endPlaceID;

  TripTransportation(this.name, this.type, this.startTime, this.endTime,
      this.startPlaceID, this.endPlaceID,
      {this.flightTrackingSlug, this.confirmationNumber});

  String get formattedStartTime => formatDate(startTime);
  String get formattedEndTime => formatDate(endTime);

  factory TripTransportation.fromFirestore(Map data) {
    Timestamp startTime = data["startTime"] as Timestamp;
    Timestamp endTime = data["endTime"] as Timestamp;
    String confirmation = data["confirmationSlug"];
    String flightTrackingSlug = data["flightTrackingSlug"];
    Transportation type = Transportation.values.byName(data["type"]);
    String startPlaceID = data["startPlaceID"];
    String endPlaceID = data["endPlaceID"];
    return TripTransportation(
      data["name"],
      type,
      startTime.toDate(),
      endTime.toDate(),
      startPlaceID,
      endPlaceID,
      flightTrackingSlug: flightTrackingSlug == "" ? null : flightTrackingSlug,
      confirmationNumber: confirmation == "" ? null : confirmation,
    );
  }
}

enum Transportation {
  rentalCar,
  ownCar,
  familyCar,
  rideshareCar,
  flight,
  train,
  boat,
  walking,
}
