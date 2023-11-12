import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_planner/classes/general.dart';

class TripAccomodation {
  final Accomodation type;
  final String name;
  final String? confirmationSlug;
  final DateTime startTime;
  final DateTime endTime;
  final GeoPoint latLng;
  final String placeID;

  TripAccomodation(this.name, this.type, this.startTime, this.endTime,
      this.latLng, this.placeID,
      {this.confirmationSlug});

  String get formattedStartTime => formatDate(startTime);
  String get formattedEndTime => formatDate(endTime);

  factory TripAccomodation.fromFirestore(Map data) {
    Timestamp startTime = data["startTime"] as Timestamp;
    Timestamp endTime = data["endTime"] as Timestamp;
    GeoPoint latLng = data["lat_lng"] as GeoPoint;
    Accomodation type = Accomodation.values.byName(data["type"]);
    String confirmationSlug = data["confirmationSlug"];
    String placeID = data["placeID"];
    return TripAccomodation(
      data["name"],
      type,
      startTime.toDate(),
      endTime.toDate(),
      latLng,
      placeID,
      confirmationSlug: confirmationSlug == "" ? null : confirmationSlug,
    );
  }
}

enum Accomodation {
  hotel,
  airbnb,
  family,
}
