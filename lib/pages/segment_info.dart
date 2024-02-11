import 'package:flutter/material.dart';
import 'package:travel_planner/classes/general.dart';

class SegmentInfo extends StatelessWidget {
  const SegmentInfo(this.segment, {super.key});
  final Segment segment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${segment.type.readableName} Details"),
      ),
      // body: ,
    );
  }
}
