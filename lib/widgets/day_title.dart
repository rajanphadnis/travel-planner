import 'package:flutter/material.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/misc_theme_data.dart';

class DayTitle extends StatelessWidget {
  const DayTitle(this.date, {super.key});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${date.day.toString().padLeft(2, "0")} ",
              style: AppTextStyle.itineraryDateNum),
          Text(months[date.month - 1], style: AppTextStyle.itineraryDate),
        ],
      ),
    );
  }
}
