import 'package:travel_planner/classes/general.dart';

class GroundTransport extends Segment {
  final String start;
  final String end;
  final String name;

  GroundTransport(
      {required this.start,
      required this.end,
      required this.name,
      required String id,
      required SegmentType type,
      required DateTime startTime,
      required DateTime endTime})
      : 
        super(startTime: startTime, endTime: endTime, id: id, type: type);

  Map<String, dynamic> get firebaseOutput => {
        "startTime": startTime,
        "endTime": endTime,
        "name": name,
        "start": start,
        "end": end,
        "id": id,
        "type": type == SegmentType.roadTrip ? "ROADTRIP" : type == SegmentType.rentalCar ? "RENTAL_CAR" : "BUS",
      };
}
