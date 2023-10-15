import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/widgets/trip_card.dart';

class TripList extends StatelessWidget {
  const TripList({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.75,
        enlargeCenterPage: true,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return TripCard(i);
          },
        );
      }).toList(),
    );
  }
}
