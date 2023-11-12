import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_planner/classes/general.dart';

class TripStop {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final int index;
  final GeoPoint latLng;
  final String placeID;

  TripStop(this.name, this.placeID, this.index, this.startTime, this.endTime,
      this.latLng);

  

  String get formattedStartDate => formatDate(startTime);
  String get formattedEndDate => formatDate(endTime);

  factory TripStop.fromFirestore(Map data) {
    Timestamp startTime = data["startTime"] as Timestamp;
    Timestamp endTime = data["endTime"] as Timestamp;
    GeoPoint latLng = data["lat_lng"] as GeoPoint;
    return TripStop(
      data["name"],
      data["placeID"],
      data["index"],
      startTime.toDate(),
      endTime.toDate(),
      latLng,
    );
  }
}
