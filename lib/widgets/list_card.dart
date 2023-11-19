// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/pages/add_accomodation.dart';
import 'package:travel_planner/pages/add_stop.dart';
import 'package:travel_planner/pages/add_transport.dart';
import 'package:travel_planner/widgets/list_card_expand.dart';

class ListCard extends StatelessWidget {
  final Trip trip;
  final int index;
  ListCard(this.trip, this.index, {super.key});
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    TripStop stop = trip.stops[index];
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stop.name),
          Text(
            " (${stop.formattedStartDate}${stop.formattedStartDate == stop.formattedEndDate ? ")" : "- ${stop.formattedEndDate})"}",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Column(
        children: [
          trip.accomodation
                  .where((accomodation) => accomodation.placeID == stop.placeID)
                  .isNotEmpty
              ? ListCardExpand(
                  header: Row(
                    children: [
                      const Icon(Icons.hotel),
                      Text(
                          " ${trip.accomodation.firstWhere((accomodation) => accomodation.placeID == stop.placeID).name}"),
                    ],
                  ),
                  isTravel: false,
                  startTime: trip.accomodation
                      .firstWhere((accomodation) =>
                          accomodation.placeID == stop.placeID)
                      .formattedStartTime,
                  endTime: trip.accomodation
                      .firstWhere((accomodation) =>
                          accomodation.placeID == stop.placeID)
                      .formattedEndTime,
                  slug: trip.accomodation
                          .firstWhere((accomodation) =>
                              accomodation.placeID == stop.placeID)
                          .confirmationSlug ??
                      "",
                  editRedirect: AddAccomodation(
                    trip,
                    accomodation: trip.accomodation.firstWhere(
                        (accomodation) => accomodation.placeID == stop.placeID),
                  ),
                )
              : Container(),
          trip.transportation
                  .where((transportation) =>
                      transportation.endPlaceID == stop.placeID)
                  .isNotEmpty
              ? ListCardExpand(
                  header: Text(
                      "Arriving by: ${trip.transportation.firstWhere((transportation) => transportation.endPlaceID == stop.placeID).name}"),
                  isTravel: true,
                  startTime: trip.transportation
                      .firstWhere((transportation) =>
                          transportation.endPlaceID == stop.placeID)
                      .formattedStartTime,
                  endTime: trip.transportation
                      .firstWhere((transportation) =>
                          transportation.endPlaceID == stop.placeID)
                      .formattedEndTime,
                  slug: trip.transportation
                          .firstWhere((transportation) =>
                              transportation.endPlaceID == stop.placeID)
                          .flightTrackingSlug ??
                      "",
                  editRedirect: AddTransport(
                    trip,
                    transportation: trip.transportation.firstWhere(
                        (transportation) =>
                            transportation.endPlaceID == stop.placeID),
                  ),
                )
              : Container(),
          trip.transportation
                  .where((transportation) =>
                      transportation.startPlaceID == stop.placeID)
                  .isNotEmpty
              ? ListCardExpand(
                  header: Text(
                      "Departing by: ${trip.transportation.firstWhere((transportation) => transportation.startPlaceID == stop.placeID).name}"),
                  isTravel: true,
                  startTime: trip.transportation
                      .firstWhere((transportation) =>
                          transportation.startPlaceID == stop.placeID)
                      .formattedStartTime,
                  endTime: trip.transportation
                      .firstWhere((transportation) =>
                          transportation.startPlaceID == stop.placeID)
                      .formattedEndTime,
                  slug: trip.transportation
                          .firstWhere((transportation) =>
                              transportation.startPlaceID == stop.placeID)
                          .flightTrackingSlug ??
                      "",
                  editRedirect: AddTransport(
                    trip,
                    transportation: trip.transportation.firstWhere(
                        (transportation) =>
                            transportation.startPlaceID == stop.placeID),
                  ),
                )
              : Container(),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStop(
                trip,
                stop: stop,
              ),
            ),
          );
        },
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
