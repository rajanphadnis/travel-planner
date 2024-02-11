// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:travel_planner/classes/flight.dart';
import 'package:travel_planner/classes/general.dart';
import 'package:travel_planner/classes/ground_transport.dart';
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
  final startingPointController = TextEditingController();
  final endingPointController = TextEditingController();
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
  final TextEditingController colorController = TextEditingController();

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
          startingPointController.value =
              TextEditingValue(text: provided.startAirport);
          endingPointController.value =
              TextEditingValue(text: provided.endAirport);
          break;
        case SegmentType.airBNB: // empty on purpose
        case SegmentType.hotel:
          nameController.value =
              TextEditingValue(text: (provided as Lodging).name);
          break;
        case SegmentType.rentalCar:
        case SegmentType.roadTrip:
        case SegmentType.bus:
          nameController.value =
              TextEditingValue(text: (provided as GroundTransport).name);
          startingPointController.value =
              TextEditingValue(text: provided.start);
          endingPointController.value = TextEditingValue(text: provided.end);
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
    startingPointController.dispose();
    endingPointController.dispose();
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
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownMenu<SegmentType>(
                    initialSelection: selectedType,
                    controller: colorController,
                    requestFocusOnTap: false,
                    label: const Text('Segment Type'),
                    onSelected: (SegmentType? color) {
                      if (color != null) {
                        setState(() {
                          selectedType = color;
                        });
                      }
                    },
                    dropdownMenuEntries: SegmentType.values
                        .map<DropdownMenuEntry<SegmentType>>(
                            (SegmentType type) {
                      return DropdownMenuEntry<SegmentType>(
                        value: type,
                        label: type.readableName,
                      );
                    }).toList(),
                  ),
                ),
                selectedType != SegmentType.roadTrip
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          autofocus: false,
                          controller: nameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: selectedType.nameInputString[0],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      )
                    : Container(),
                !selectedType.isLodging
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              autofocus: false,
                              controller: startingPointController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: selectedType.nameInputString[1],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              autofocus: false,
                              controller: endingPointController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: selectedType.nameInputString[2],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () => _selectStartDate(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const Text(
                                    "Start Date",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      selectedType.isLodging
                                          ? selectedStartDate
                                              .toLocal()
                                              .toString()
                                              .split(" ")[0]
                                          : formatDateAndTime(
                                              selectedStartDate, '\n'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () => _selectEndDate(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const Text(
                                    "End Date",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      selectedType.isLodging
                                          ? selectedEndDate
                                              .toLocal()
                                              .toString()
                                              .split(" ")[0]
                                          : formatDateAndTime(
                                              selectedEndDate, '\n'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.id == "") {
                      switch (selectedType) {
                        case SegmentType.flight:
                          widget.trip.createSegment(Flight(
                              startAirport: startingPointController.value.text,
                              endAirport: endingPointController.value.text,
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
                        case SegmentType.rentalCar:
                          widget.trip.createSegment(GroundTransport(
                              start: startingPointController.value.text,
                              end: endingPointController.value.text,
                              name: nameController.value.text,
                              type: SegmentType.rentalCar,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        case SegmentType.roadTrip:
                          widget.trip.createSegment(GroundTransport(
                              start: startingPointController.value.text,
                              end: endingPointController.value.text,
                              name: "Roadtrip",
                              type: SegmentType.roadTrip,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        case SegmentType.bus:
                          widget.trip.createSegment(GroundTransport(
                              start: startingPointController.value.text,
                              end: endingPointController.value.text,
                              name: nameController.value.text,
                              type: SegmentType.bus,
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
                              startAirport: startingPointController.value.text,
                              endAirport: endingPointController.value.text,
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
                        case SegmentType.rentalCar:
                          widget.trip.updateSegment(GroundTransport(
                              start: startingPointController.value.text,
                              end: endingPointController.value.text,
                              name: nameController.value.text,
                              type: SegmentType.rentalCar,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        case SegmentType.roadTrip:
                          widget.trip.updateSegment(GroundTransport(
                              start: startingPointController.value.text,
                              end: endingPointController.value.text,
                              name: "Roadtrip",
                              type: SegmentType.roadTrip,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        case SegmentType.bus:
                          widget.trip.updateSegment(GroundTransport(
                              start: startingPointController.value.text,
                              end: endingPointController.value.text,
                              name: nameController.value.text,
                              type: SegmentType.bus,
                              startTime: selectedStartDate,
                              endTime: selectedEndDate,
                              id: genRandomString(10)));
                          break;
                        default:
                          debugPrint("default update");
                      }
                    }
                    Navigator.pop(context);
                    widget.trip.triggerUpdate();
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
