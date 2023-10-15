import 'package:cloud_firestore/cloud_firestore.dart';

class TripAccomodation {
  final Accomodation type;
  final String name;
  final String? confirmationSlug;
  final DateTime startTime;
  final DateTime endTime;
  final GeoPoint latLng;

  TripAccomodation(
      this.name, this.type, this.startTime, this.endTime, this.latLng,
      {this.confirmationSlug});

  factory TripAccomodation.fromFirestore(Map data) {
    Timestamp startTime = data["startTime"] as Timestamp;
    Timestamp endTime = data["endTime"] as Timestamp;
    GeoPoint latLng = data["lat_lng"] as GeoPoint;
    Accomodation type = Accomodation.values.byName(data["type"]);
    String confirmationSlug = data["confirmationSlug"];
    return TripAccomodation(
      data["name"],
      type,
      startTime.toDate(),
      endTime.toDate(),
      latLng,
      confirmationSlug: confirmationSlug == "" ? null : confirmationSlug,
    );
  }
}

enum Accomodation {
  hotel,
  airbnb,
  family,
}
