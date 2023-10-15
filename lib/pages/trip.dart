import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/widgets/itinerary.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trip.name), actions: [
        IconButton(onPressed: () {
          
        }, icon: const Icon(Icons.add),),
      ],),
      body: Center(
        child: Itinerary(trip),
      ),
    );
  }
}
