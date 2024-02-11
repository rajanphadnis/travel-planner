import 'package:flutter/material.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/lodging.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/misc_theme_data.dart';
import 'package:travel_planner/pages/add_segment.dart';

class LodgingCard extends StatelessWidget {
  const LodgingCard(this.lodging, this.trip, {super.key});
  final Lodging lodging;
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
                id: lodging.id,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    lodging.type.cardIcon,
                    color: Colors.black,
                  ),
                ),
                Text(lodging.name, style: AppTextStyle.itineraryLodgingName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    "${lodging.startDateShortFormatted} - ${lodging.endDateShortFormatted}",
                    style: AppTextStyle.itineraryLodgingDate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
