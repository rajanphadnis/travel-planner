import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/pages/add_segment.dart';

class AddSegmentButton extends StatelessWidget {
  const AddSegmentButton(this.trip, {super.key});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddSegment(trip)));
      },
      icon: const Icon(Icons.add),
      label: const Text("Add Segment"),
    );
  }
}
