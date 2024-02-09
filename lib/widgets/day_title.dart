import 'package:flutter/material.dart';
import 'package:travel_planner/misc_theme_data.dart';

class DayTitle extends StatelessWidget {
  const DayTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("04 ", style: AppTextStyle.itineraryDateNum),
          Text("May - Washington DC", style: AppTextStyle.itineraryDate),
        ],
      ),
    );
  }
}
