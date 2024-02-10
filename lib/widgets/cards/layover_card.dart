import 'package:flutter/material.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/misc_theme_data.dart';

class LayoverCard extends StatelessWidget {
  const LayoverCard(this.flightEnd, this.flightStart, this.layoverAirport,
      {super.key});
  final DateTime flightEnd;
  final DateTime flightStart;
  final Flight layoverAirport;

  @override
  Widget build(BuildContext context) {
    Duration time = flightStart.difference(flightEnd);
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 70, 70, 70),
      ),
      child: Column(
        children: [
          Text("Layover: ${layoverAirport.startAirportTitle}",
              style: AppTextStyle.itineraryLayoverTitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // HorizontalSeparator(),
              Text("${(time.inMinutes / 60).floor()}h ${time.inMinutes % 60}m",
                  style: AppTextStyle.itineraryLayoverTime),
              // HorizontalSeparator(),
            ],
          ),
        ],
      ),
    );
  }
}
