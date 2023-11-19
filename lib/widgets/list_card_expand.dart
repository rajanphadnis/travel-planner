import 'package:flutter/material.dart';

class ListCardExpand extends StatefulWidget {
  final Widget header;
  final bool isTravel;
  final String startTime;
  final String endTime;
  final String slug;
  final Widget editRedirect;
  const ListCardExpand({
    super.key,
    required this.header,
    required this.isTravel,
    required this.startTime,
    required this.endTime,
    required this.slug,
    required this.editRedirect,
  });

  @override
  State<ListCardExpand> createState() => _ListCardExpandState();
}

class _ListCardExpandState extends State<ListCardExpand> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              icon: isOpen
                  ? const Icon(Icons.keyboard_arrow_up)
                  : const Icon(Icons.keyboard_arrow_down),
            ),
            widget.header,
          ],
        ),
        !isOpen
            ? Container()
            : Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.isTravel ? "Depart: " : "Check In: ",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(widget.startTime)
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.isTravel ? "Arrive: " : "Check Out: ",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(widget.endTime)
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.isTravel ? "Flight #: " : "Reservation #: ",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(widget.slug)
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => widget.editRedirect,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"))
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}
