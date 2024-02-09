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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     IconButton(
          //       // iconSize: ,
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => AddTrip(trip: trip)));
          //       },
          //       icon: const Icon(Icons.edit),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => AddStop(trip)));
          //       },
          //       icon: const Icon(Icons.location_on),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => AddTransport(trip)));
          //       },
          //       icon: const Icon(Icons.drive_eta),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => AddAccomodation(trip)));
          //       },
          //       icon: const Icon(Icons.hotel),
          //     ),
          //   ],
          // ),
          Expanded(
            child: Itinerary(trip),
          ),
        ],
      ),
    );
  }
}
