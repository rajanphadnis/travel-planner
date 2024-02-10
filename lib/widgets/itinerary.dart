import 'package:flutter/material.dart';
import 'package:travel_planner/classes/itinerary_filter.dart';
import 'package:travel_planner/classes/trip.dart';

class Itinerary extends StatelessWidget {
  final Trip trip;
  const Itinerary(this.trip, {super.key});

  final bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> itineraryList = genItineraryList(trip, context);
    return isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
              children: itineraryList,
            ),
          );
  }
}
