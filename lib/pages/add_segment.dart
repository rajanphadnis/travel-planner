// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/lodging.dart';
import 'package:travel_planner/classes/trip.dart';

class AddSegment extends StatefulWidget {
  final Trip trip;
  final String id;
  const AddSegment(this.trip, {super.key, this.id = ""});

  @override
  State<AddSegment> createState() => _AddSegmentState();
}

class _AddSegmentState extends State<AddSegment> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final flightStartController = TextEditingController();
  final flightEndController = TextEditingController();
  SegmentType selectedType = SegmentType.flight;
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
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    picked ??= DateTime.now();
    final TimeOfDay? selectedTime = selectedType.isLodging
        ? TimeOfDay.fromDateTime(picked)
        : await showTimePicker(
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
    if (toSet != selectedEndDate) {
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
    final TimeOfDay? selectedTime = selectedType.isLodging
        ? TimeOfDay.fromDateTime(picked)
        : await showTimePicker(
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
    if (toSet != selectedStartDate) {
      setState(() {
        selectedStartDate = toSet;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != "") {
      Segment provided =
          widget.trip.segments.firstWhere((seg) => seg.id == widget.id);
      selectedStartDate = provided.startTime;
      selectedEndDate = provided.endTime;
      selectedType = provided.type;
      switch (provided.type) {
        case SegmentType.flight:
          nameController.value =
              TextEditingValue(text: (provided as Flight).flightNumber);
          flightStartController.value =
              TextEditingValue(text: provided.startAirport);
          flightEndController.value =
              TextEditingValue(text: provided.endAirport);
          break;
        case SegmentType.airBNB: // empty on purpose
        case SegmentType.hotel:
          nameController.value =
              TextEditingValue(text: (provided as Lodging).name);
          break;
        default:
          debugPrint("not init");
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    flightStartController.dispose();
    flightEndController.dispose();
    super.dispose();
  }

  Future<void> _confirmDeleteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete ${selectedType.readableName}?"),
          content:
              const Text("Please confirm you'd like to delete this segment"),
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
                SegmentType type = widget.trip.segments
                    .firstWhere((seg) => seg.id == widget.id)
                    .type;
                widget.trip.deleteSegment(widget.id, type).then((value) {
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
        title: Text(widget.id == ""
            ? "Add ${selectedType.readableName}"
            : "Edit ${selectedType.readableName}"),
        actions: [
          widget.id != ""
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
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      title: const Text('Flight'),
                      leading: Radio<SegmentType>(
                        value: SegmentType.flight,
                        groupValue: selectedType,
                        onChanged: (SegmentType? value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Hotel'),
                      leading: Radio<SegmentType>(
                        value: SegmentType.hotel,
                        groupValue: selectedType,
                        onChanged: (SegmentType? value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('AirBNB'),
                      leading: Radio<SegmentType>(
                        value: SegmentType.airBNB,
                        groupValue: selectedType,
                        onChanged: (SegmentType? value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Text(selectedType.nameInputString),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                selectedType == SegmentType.flight
                    ? Column(
                        children: [
                          const Text("Starting Airport Code:"),
                          TextFormField(
                            controller: flightStartController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const Text("Ending Airport Code:"),
                          TextFormField(
                            controller: flightEndController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ],
                      )
                    : Container(),
                ElevatedButton.icon(
                  onPressed: () => _selectStartDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                      "Start Date: ${selectedType.isLodging ? selectedStartDate.toLocal().toString().split(" ")[0] : formatDateAndTime(selectedStartDate, '@')}"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectEndDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                      "End Date: ${selectedType.isLodging ? selectedEndDate.toLocal().toString().split(" ")[0] : formatDateAndTime(selectedEndDate, '@')}"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.id == "") {
                      switch (selectedType) {
                        case SegmentType.flight:
                          widget.trip.createSegment(Flight(
                              startAirport: flightStartController.value.text,
                              endAirport: flightEndController.value.text,
                              flightNumber: nameController.value.text,
                              id: genRandomString(10),
                              type: SegmentType.flight,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate));
                          break;
                        case SegmentType.hotel:
                          widget.trip.createSegment(Lodging(
                              name: nameController.value.text,
                              type: SegmentType.hotel,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        case SegmentType.airBNB:
                          widget.trip.createSegment(Lodging(
                              name: nameController.value.text,
                              type: SegmentType.airBNB,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        default:
                          debugPrint("default create new");
                      }
                    } else {
                      switch (selectedType) {
                        case SegmentType.flight:
                          widget.trip.updateSegment(Flight(
                              startAirport: flightStartController.value.text,
                              endAirport: flightEndController.value.text,
                              flightNumber: nameController.value.text,
                              id: widget.id,
                              type: SegmentType.flight,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate));
                          break;
                        case SegmentType.hotel:
                          widget.trip.updateSegment(Lodging(
                              name: nameController.value.text,
                              type: SegmentType.hotel,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: widget.id));
                          break;
                        case SegmentType.airBNB:
                          widget.trip.updateSegment(Lodging(
                              name: nameController.value.text,
                              type: SegmentType.airBNB,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: widget.id));
                          break;
                        default:
                          debugPrint("default update");
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
