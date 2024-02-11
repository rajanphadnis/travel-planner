import 'package:flutter/material.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/ground_transport.dart';
import 'package:travel_planner/classes/lodging.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/widgets/add_segment_button.dart';
import 'package:travel_planner/widgets/cards/flight_card.dart';
import 'package:travel_planner/widgets/cards/ground_transport_card.dart';
import 'package:travel_planner/widgets/cards/layover_card.dart';
import 'package:travel_planner/widgets/cards/lodging_card.dart';
import 'package:travel_planner/widgets/day_title.dart';

String formatDateString(DateTime date) {
  String year = date.year.toString().substring(2);
  String month = date.month.toString();
  String day = date.day.toString();
  return "$month$day$year";
}

List<Widget> genItineraryList(Trip trip, BuildContext context) {
  List<Segment> segments = trip.segments;
  List<Widget> itineraryList = [
    DayTitle(segments[0].startTime),
  ];
  bool isFirstEventOfDay = true;
  SegmentType previousSegment = segments[0].type;
  String currentDate = formatDateString(segments[0].startTime);

  for (var i = 0; i < segments.length; i++) {
    Segment segment = segments[i];
    if (formatDateString(segment.startTime) != currentDate) {
      itineraryList.add(DayTitle(segment.startTime));
      currentDate = formatDateString(segment.startTime);
      isFirstEventOfDay = true;
    }
    switch (segment.type) {
      case SegmentType.flight:
        if (previousSegment == SegmentType.flight && !isFirstEventOfDay) {
          DateTime prevEndTime = segments[i - 1].endTime;
          itineraryList.add(
              LayoverCard(prevEndTime, segment.startTime, (segment as Flight)));
        } else if (!isFirstEventOfDay) {
          itineraryList.add(const Padding(padding: EdgeInsets.only(top: 20)));
        }
        itineraryList.add(FlightCard(segment as Flight, trip));
        break;

      case SegmentType.hotel:
      case SegmentType.airBNB:
        if (!isFirstEventOfDay) {
          itineraryList.add(const Padding(padding: EdgeInsets.only(top: 20)));
        }
        itineraryList.add(LodgingCard(segment as Lodging, trip));
        break;

      case SegmentType.rentalCar:
      case SegmentType.roadTrip:
      case SegmentType.bus:
        if (!isFirstEventOfDay) {
          itineraryList.add(const Padding(padding: EdgeInsets.only(top: 20)));
        }
        itineraryList
            .add(GroundTransportCard(segment as GroundTransport, trip));
        break;
      default:
        debugPrint("noneTYYYYPPPEE");
    }
    isFirstEventOfDay = false;
    previousSegment = segment.type;
  }
  itineraryList.add(const Padding(padding: EdgeInsets.only(top: 20)));
  itineraryList.add(
    AddSegmentButton(trip),
  );

  return itineraryList;
}
