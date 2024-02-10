import 'package:flutter/material.dart';
import 'package:travel_planner/classes/itinerary_filter.dart';
import 'package:travel_planner/classes/trip.dart';

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
        List<Widget> itineraryList = genItineraryList(widget.trip, context);
        return isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: itineraryList,
                ),
              );
      },
    );
  }
}
