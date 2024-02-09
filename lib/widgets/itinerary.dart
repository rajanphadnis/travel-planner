import 'package:flutter/material.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/lodging.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/pages/add_segment.dart';
import 'package:travel_planner/widgets/day_title.dart';
import 'package:travel_planner/widgets/flight_card.dart';
import 'package:travel_planner/widgets/layover_card.dart';
import 'package:travel_planner/widgets/lodging_card.dart';

class Itinerary extends StatefulWidget {
  final Trip trip;
  const Itinerary(this.trip, {super.key});

  @override
  State<Itinerary> createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: widget.trip.stream,
        builder: (context, snapshot) {
          List<Widget> itineraryList = [
            const DayTitle(),
          ];
          for (var segment in widget.trip.segments) {
            switch (segment.type) {
              case SegmentType.flight:
                itineraryList.add(FlightCard(segment as Flight, widget.trip));
                itineraryList
                    .add(const Padding(padding: EdgeInsets.only(top: 20)));
                break;
              case SegmentType.hotel:
                itineraryList.add(LodgingCard(segment as Lodging, widget.trip));
                itineraryList
                    .add(const Padding(padding: EdgeInsets.only(top: 20)));
                break;
              case SegmentType.airBNB:
                itineraryList.add(LodgingCard(segment as Lodging, widget.trip));
                itineraryList
                    .add(const Padding(padding: EdgeInsets.only(top: 20)));
                break;
              case SegmentType.SPACE:
                itineraryList
                    .add(const Padding(padding: EdgeInsets.only(top: 20)));
                break;
              case SegmentType.LAYOVER:
                itineraryList.add(const LayoverCard());
                break;
              default:
                debugPrint("noneTYYYYPPPEE");
            }
          }
          itineraryList.add(ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSegment(widget.trip)));
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Segment")));
          return isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: itineraryList,
                  ),
                );

          // CustomScrollView(
          //     controller: scrollController,
          //     slivers: <Widget>[
          //       ReorderableSliverList(
          //         delegate: ReorderableSliverChildBuilderDelegate(
          //           (context, index) {
          //             return ListCard(widget.trip, index);
          //           },
          //           childCount: widget.trip.stops.length,
          //         ),
          //         onReorder: onReorder,
          //       ),
          //     ],
          //   );
        });
  }
}
