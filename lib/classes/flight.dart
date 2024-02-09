import 'package:travel_planner/classes/general.dart';

class Flight extends Segment {
  String startAirport;
  String endAirport;
  String flightNumber;

  Flight(
      {required this.startAirport,
      required this.endAirport,
      required this.flightNumber,
      required String id,
      required SegmentType type,
      required DateTime startTime,
      required DateTime endTime})
      : super(startTime: startTime, endTime: endTime, id: id, type: type);

  Map<String, dynamic> get firebaseOutput => {
        "startTime": startTime,
        "endTime": endTime,
        "flightNumber": flightNumber,
        "startAirport": startAirport,
        "endAirport": endAirport,
        "id": id,
        "type": "FLIGHT",
      };
}
