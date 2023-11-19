import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/transportation.dart';
import 'package:travel_planner/classes/trip.dart';

class AddTransport extends StatefulWidget {
  final Trip trip;
  final TripTransportation? transportation;
  const AddTransport(this.trip, {super.key, this.transportation});

  @override
  State<AddTransport> createState() => _AddTransportState();
}

class _AddTransportState extends State<AddTransport> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  DateTime selectedStartDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime selectedEndDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  late TripStop tempStartStop;
  late TripStop tempEndStop;
  late TripStop startStop;
  late TripStop endStop;
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Transportation transportType = Transportation.ownCar;

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.transportation != null) {
      selectedStartDate = widget.transportation!.startTime;
      selectedEndDate = widget.transportation!.endTime;
      nameController.value =
          TextEditingValue(text: widget.transportation!.name);
      transportType = widget.transportation!.type;
    }
    startStop = widget.transportation == null
        ? widget.trip.stops.first
        : widget.trip.stops
            .where((element) =>
                element.placeID == widget.transportation!.startPlaceID)
            .first;
    endStop = widget.transportation == null
        ? widget.trip.stops.first
        : widget.trip.stops
            .where((element) =>
                element.placeID == widget.transportation!.endPlaceID)
            .first;
    tempStartStop = startStop;
    tempEndStop = endStop;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  Future<void> _stopDialogBuilder(BuildContext context, bool isStartSelector) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              isStartSelector ? 'Select Starting Stop' : "Select Ending Stop"),
          content: DropdownMenu<TripStop>(
            initialSelection: widget.trip.stops.first,
            onSelected: (TripStop? value) {
              // This is called when the user selects an item.
              setState(() {
                if (isStartSelector) {
                  tempStartStop = value!;
                } else {
                  tempEndStop = value!;
                }
              });
            },
            dropdownMenuEntries: widget.trip.stops
                .map<DropdownMenuEntry<TripStop>>((TripStop value) {
              return DropdownMenuEntry<TripStop>(
                  value: value, label: value.dropdownEntry);
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () {
                setState(() {
                  if (isStartSelector) {
                    startStop = tempStartStop;
                  } else {
                    endStop = tempEndStop;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transportation"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton.icon(
                onPressed: () => _selectStartDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                    "Depart: ${selectedStartDate.toLocal().toString().split(" ")[0]}"),
              ),
              ElevatedButton.icon(
                onPressed: () => _selectEndDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                    "Arrive: ${selectedEndDate.toLocal().toString().split(" ")[0]}"),
              ),
              DropdownMenu<Transportation>(
                initialSelection: transportType,
                onSelected: (Transportation? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    transportType = value!;
                  });
                },
                dropdownMenuEntries: Transportation.values
                    .map<DropdownMenuEntry<Transportation>>(
                        (Transportation value) {
                  return DropdownMenuEntry<Transportation>(
                      value: value, label: value.name);
                }).toList(),
              ),
              ElevatedButton.icon(
                onPressed: () => _stopDialogBuilder(context, true),
                icon: const Icon(Icons.location_on),
                label: Text("Starting at: ${startStop.dropdownEntry}"),
              ),
              ElevatedButton.icon(
                onPressed: () => _stopDialogBuilder(context, false),
                icon: const Icon(Icons.location_on),
                label: Text("Ending at: ${endStop.dropdownEntry}"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.transportation != null) {
                    widget.trip
                        .updateTransportation(
                      widget.transportation!,
                      startStop,
                      endStop,
                      transportType,
                      nameController.value.text,
                      selectedStartDate,
                      selectedEndDate,
                      const GeoPoint(28.543091, -80.665339),
                      null,
                      null,
                    )
                        .then(
                      (value) {
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    widget.trip
                        .addTransportation(
                      TripTransportation(
                        nameController.value.text,
                        transportType,
                        selectedStartDate,
                        selectedEndDate,
                        startStop.placeID,
                        endStop.placeID,
                        confirmationNumber: null,
                        flightTrackingSlug: null,
                      ),
                    )
                        .then(
                      (value) {
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}