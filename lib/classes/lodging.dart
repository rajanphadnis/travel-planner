import 'package:travel_planner/classes/general.dart';

class Lodging extends Segment {
  String name;

  Lodging(
      {required this.name,
      required SegmentType type,
      required DateTime startTime,
      required DateTime endTime,
      required String id})
      : super(startTime: startTime, endTime: endTime, id: id, type: type);

  Map<String, dynamic> get firebaseOutput => {
        "startTime": startTime,
        "endTime": endTime,
        "name": name,
        "id": id,
        "type": type == SegmentType.airBNB ? "AIRBNB" : "HOTEL",
      };
}
