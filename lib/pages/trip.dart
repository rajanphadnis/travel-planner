import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/pages/add_accomodation.dart';
import 'package:travel_planner/pages/add_stop.dart';
import 'package:travel_planner/pages/add_transport.dart';
import 'package:travel_planner/widgets/itinerary.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddStop(trip)));
            },
            icon: const Icon(Icons.location_on),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTransport(trip)));
            },
            icon: const Icon(Icons.drive_eta),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAccomodation(trip)));
            },
            icon: const Icon(Icons.hotel),
          ),
        ],
      ),
      body: Center(
        child: Itinerary(trip),
      ),
    );
  }
}
