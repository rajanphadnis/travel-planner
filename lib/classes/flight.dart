import 'package:travel_planner/classes/airport_data.dart';
import 'package:travel_planner/classes/general.dart';

class Flight extends Segment {
  final String startAirport;
  final String endAirport;
  final String flightNumber;
  final Airport startAirportData;
  final Airport endAirportData;

  Flight(
      {required this.startAirport,
      required this.endAirport,
      required this.flightNumber,
      required String id,
      required SegmentType type,
      required DateTime startTime,
      required DateTime endTime})
      : startAirportData = AirportData().airportSearch(startAirport),
        endAirportData = AirportData().airportSearch(endAirport),
        super(startTime: startTime, endTime: endTime, id: id, type: type);

  Map<String, dynamic> get firebaseOutput => {
        "startTime": startTime,
        "endTime": endTime,
        "flightNumber": flightNumber,
        "startAirport": startAirport,
        "endAirport": endAirport,
        "id": id,
        "type": "FLIGHT",
      };

  String get startAirportTitle =>
      startAirportData.city ?? startAirportData.name;
  String get endAirportTitle => endAirportData.city ?? endAirportData.name;
}
