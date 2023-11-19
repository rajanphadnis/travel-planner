// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/general.dart';
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
  final confirmationSlugController = TextEditingController();
  final flightSlugController = TextEditingController();
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
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    picked ??= DateTime.now();
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(picked),
    );
    final DateTime toSet = selectedTime == null
        ? picked
        : DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
    if (picked != selectedEndDate) {
      setState(() {
        selectedEndDate = toSet;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    picked ??= DateTime.now();
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(picked),
    );
    final DateTime toSet = selectedTime == null
        ? picked
        : DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
    if (picked != selectedEndDate) {
      setState(() {
        selectedStartDate = toSet;
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
      flightSlugController.value = TextEditingValue(
          text: widget.transportation!.flightTrackingSlug ?? "");
      confirmationSlugController.value = TextEditingValue(
          text: widget.transportation!.confirmationNumber ?? "");
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
    flightSlugController.dispose();
    confirmationSlugController.dispose();
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

  Future<void> _confirmDeleteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Transportation?"),
          content: Text(
              "Please confirm you'd like to delete the transportation called '${nameController.value.text}'"),
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
                widget.trip
                    .deleteTransportation(widget.transportation!)
                    .then((value) {
                  Navigator.of(context).pop();
                });
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
        actions: [
          widget.transportation != null
              ? IconButton(
                  onPressed: () {
                    _confirmDeleteDialog(context).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(Icons.delete),
                )
              : Container(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const Text("Transportation Name:"),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Text("Flight Number:"),
              TextFormField(
                controller: flightSlugController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Text("Confirmation Number:"),
              TextFormField(
                controller: confirmationSlugController,
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
                    "Depart: ${formatDateAndTime(selectedStartDate, '@')}"),
              ),
              ElevatedButton.icon(
                onPressed: () => _selectEndDate(context),
                icon: const Icon(Icons.calendar_today),
                label:
                    Text("Arrive: ${formatDateAndTime(selectedEndDate, '@')}"),
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
                      confirmationSlugController.value.text,
                      flightSlugController.value.text,
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
                        confirmationNumber:
                            confirmationSlugController.value.text,
                        flightTrackingSlug: flightSlugController.value.text,
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
