import 'package:flutter/material.dart';
import 'package:travel_planner/classes/airport_data.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/misc_theme_data.dart';
import 'package:travel_planner/pages/add_segment.dart';

class FlightCard extends StatelessWidget {
  const FlightCard(this.flight, this.trip, {super.key});
  final Flight flight;
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSegment(
                trip,
                id: flight.id,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    flight.startAirportTitle,
                    style: AppTextStyle.itineraryCityName),
                Text(flight.endAirportTitle,
                    style: AppTextStyle.itineraryCityName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(flight.startAirport,
                        style: AppTextStyle.itineraryAirportCode),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(flight.startTimeFormatted,
                          style: AppTextStyle.itineraryDepartArriveTime),
                    ),
                  ],
                ),
                const Icon(
                  Icons.flight_takeoff_rounded,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Text(flight.endTimeFormatted,
                          style: AppTextStyle.itineraryDepartArriveTime),
                    ),
                    Text(flight.endAirport,
                        style: AppTextStyle.itineraryAirportCode),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  flight.flightNumber,
                  style: AppTextStyle.itineraryFlightNumber,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
