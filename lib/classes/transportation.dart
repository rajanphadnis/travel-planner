import 'package:cloud_firestore/cloud_firestore.dart';

class TripTransportation {
  final String name;
  final Transportation type;
  final String? flightTrackingSlug;
  final String? confirmationNumber;
  final DateTime startTime;
  final DateTime endTime;

  TripTransportation(this.name, this.type, this.startTime, this.endTime,
      {this.flightTrackingSlug, this.confirmationNumber});

  factory TripTransportation.fromFirestore(Map data) {
    Timestamp startTime = data["startTime"] as Timestamp;
    Timestamp endTime = data["endTime"] as Timestamp;
    String confirmation = data["confirmation"];
    String flightTrackingSlug = data["flightTrackingSlug"];
    Transportation type = Transportation.values.byName(data["type"]);
    return TripTransportation(
      data["name"],
      type,
      startTime.toDate(),
      endTime.toDate(),
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
