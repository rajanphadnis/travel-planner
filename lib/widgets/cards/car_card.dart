import 'package:flutter/material.dart';
import 'package:travel_planner/misc_theme_data.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.hotel,
                  color: Colors.black,
                ),
              ),
              Text("Hertz - Compact", style: AppTextStyle.itineraryLodgingName),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("05/04 - 05/12", style: AppTextStyle.itineraryLodgingDate),
            ],
          ),
        ],
      ),
    );
  }
}
