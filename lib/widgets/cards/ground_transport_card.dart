import 'package:flutter/material.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/ground_transport.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/misc_theme_data.dart';
import 'package:travel_planner/pages/add_segment.dart';

class GroundTransportCard extends StatelessWidget {
  const GroundTransportCard(this.ground, this.trip, {super.key});
  final GroundTransport ground;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSegment(
                trip,
                id: ground.id,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    ground.type.cardIcon,
                    color: Colors.black,
                  ),
                ),
                Text(ground.name,
                    style: AppTextStyle.itineraryGroundTransportName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${ground.startDateShortFormatted} - ${ground.endDateShortFormatted}",
                    style: AppTextStyle.itineraryGroundTransportDate),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${ground.start} -> ${ground.end}",
                    style: AppTextStyle.itineraryGroundTransportPath),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
