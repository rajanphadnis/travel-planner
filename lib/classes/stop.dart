import 'package:cloud_firestore/cloud_firestore.dart';

class TripStop {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final int index;
  final GeoPoint latLng;

  TripStop(this.name, this.index, this.startTime, this.endTime, this.latLng);

  factory TripStop.fromFirestore(Map data) {
    Timestamp startTime = data["startTime"] as Timestamp;
    Timestamp endTime = data["endTime"] as Timestamp;
    GeoPoint latLng = data["lat_lng"] as GeoPoint;
    return TripStop(
      data["name"],
      data["index"],
      startTime.toDate(),
      endTime.toDate(),
      latLng,
    );
  }
}
