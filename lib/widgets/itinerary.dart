import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';

class Itinerary extends StatelessWidget {
  final Trip trip;
  const Itinerary(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(trip.stops.toList().toString()),
        Text(trip.transportation.toList().toString()),
        Text(trip.accomodation.toList().toString()),
      ],
    );
  }
}
