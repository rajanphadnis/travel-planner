import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/trip.dart';
import 'package:travel_planner/widgets/list_card.dart';

class Itinerary extends StatefulWidget {
  final Trip trip;
  const Itinerary(this.trip, {super.key});

  @override
  State<Itinerary> createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  late List<Widget> _rows;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _rows = List<Widget>.generate(50,
        (int index) => Text('This is sliver child $index', textScaleFactor: 2));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _onReorder(int oldIndex, int newIndex) async {
      setState(() {
        isLoading = true;
      });
      await widget.trip.updateStopOrder(oldIndex, newIndex);
      setState(() {
        isLoading = false;
      });
    }

    ScrollController _scrollController =
        PrimaryScrollController.of(context);

    return StreamBuilder<bool>(
        stream: widget.trip.stream,
        builder: (context, snapshot) {
          return isLoading
              ? const CircularProgressIndicator()
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    ReorderableSliverList(
                      delegate: ReorderableSliverChildBuilderDelegate(
                        (context, index) {
                          return ListCard(widget.trip, index);
                        },
                        childCount: widget.trip.stops.length,
                      ),
                      onReorder: _onReorder,
                    ),
                  ],
                );
        });
  }
}
