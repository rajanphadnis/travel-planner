import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/widgets/trip_card.dart';

class TripList extends StatelessWidget {
  const TripList({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<Widget> getTrips(QuerySnapshot<Object?>? data) {
      List<Widget> toReturn = [];
      for (var i = 0; i < data!.docs.length; i++) {
        toReturn.add(TripCard(i, Trip.fromFirestore(data.docs[i])));
      }
      return toReturn;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users/$uid/activeTrips')
          .orderBy("startTime")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.75,
            enlargeCenterPage: true,
          ),
          items: getTrips(snapshot.data),
        );
      },
    );
  }
}
