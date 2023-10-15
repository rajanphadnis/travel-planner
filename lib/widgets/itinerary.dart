import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:travel_planner/classes/trip.dart';

class Itinerary extends StatefulWidget {
  final Trip trip;
  const Itinerary(this.trip, {super.key});

  @override
  State<Itinerary> createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  late List<Widget> _rows;

  @override
  void initState() {
    super.initState();
    _rows = List<Widget>.generate(50,
        (int index) => Text('This is sliver child $index', textScaleFactor: 2));
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _rows.removeAt(oldIndex);
        _rows.insert(newIndex, row);
      });
    }

    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        ReorderableSliverList(
          delegate: ReorderableSliverChildBuilderDelegate(
            (context, index) {
              return Text(widget.trip.stops[index].name);
            },
            childCount: widget.trip.stops.length,
          ),
          onReorder: _onReorder,
        ),
      ],
    );
  }
}
