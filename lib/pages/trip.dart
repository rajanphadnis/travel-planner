import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/itinerary_filter.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/pages/add_trip.dart';
import 'package:travel_planner/pages/loading.dart';
import 'package:travel_planner/widgets/add_segment_button.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;
  const TripScreen(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users/$uid/activeTrips')
            .doc(trip.docID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          }
          Trip updatedTrip = Trip.fromFirestore(snapshot.data);
          if (updatedTrip.segments.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(updatedTrip.name),
                    Text(
                      " (${updatedTrip.formattedStartDate})",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddTrip(trip: updatedTrip)));
                    },
                    icon: const Icon(Icons.edit),
                    // label: const Text("Edit Trip"),
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("No trip segments found"),
                    AddSegmentButton(trip)
                  ],
                ),
              ),
            );
          }
          List<Widget> itineraryList = genItineraryList(updatedTrip, context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(updatedTrip.name),
                  Text(
                    " (${updatedTrip.formattedStartDate})",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTrip(trip: updatedTrip)));
                  },
                  icon: const Icon(Icons.edit),
                  // label: const Text("Edit Trip"),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: itineraryList,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
