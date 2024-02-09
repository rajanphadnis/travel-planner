import 'package:flutter/material.dart';
import 'package:travel_planner/misc_theme_data.dart';

class LayoverCard extends StatelessWidget {
  const LayoverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 70, 70, 70),
                        ),
                        child: const Column(
                          children: [
                            Text("Layover",
                                style: AppTextStyle.itineraryLayoverTitle),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // HorizontalSeparator(),
                                Text("2h 10m",
                                    style: AppTextStyle.itineraryLayoverTime),
                                // HorizontalSeparator(),
                              ],
                            ),
                          ],
                        ),
                      );
  }
}