import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/widgets/itinerary.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(trip.name),
            Text(
              " (${trip.formattedStartDate})",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Itinerary(trip),
          ),
        ],
      ),
    );
  }
}
