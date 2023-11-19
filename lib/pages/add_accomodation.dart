import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/accomodation.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/trip.dart';

class AddAccomodation extends StatefulWidget {
  final Trip trip;
  final TripAccomodation? accomodation;
  const AddAccomodation(this.trip, {super.key, this.accomodation});

  @override
  State<AddAccomodation> createState() => _AddAccomodationState();
}

class _AddAccomodationState extends State<AddAccomodation> {
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
  late TripStop tempStop;
  late TripStop tripStop;
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Accomodation accomodationType = Accomodation.hotel;

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
    if (widget.accomodation != null) {
      selectedStartDate = widget.accomodation!.startTime;
      selectedEndDate = widget.accomodation!.endTime;
      nameController.value = TextEditingValue(text: widget.accomodation!.name);
    }
    tempStop = widget.accomodation == null
        ? widget.trip.stops.first
        : widget.trip.stops
            .where((element) => element.placeID == widget.accomodation!.placeID)
            .first;
    tripStop = tempStop;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  Future<void> _stopDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select associated stop"),
          content: DropdownMenu<TripStop>(
            initialSelection: widget.trip.stops.first,
            onSelected: (TripStop? value) {
              // This is called when the user selects an item.
              setState(() {
                tempStop = value!;
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
                  tripStop = tempStop;
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
        title: const Text("Add Accomodation"),
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
              DropdownMenu<Accomodation>(
                initialSelection: accomodationType,
                onSelected: (Accomodation? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    accomodationType = value!;
                  });
                },
                dropdownMenuEntries: Accomodation.values
                    .map<DropdownMenuEntry<Accomodation>>((Accomodation value) {
                  return DropdownMenuEntry<Accomodation>(
                      value: value, label: value.name);
                }).toList(),
              ),
              ElevatedButton.icon(
                onPressed: () => _stopDialogBuilder(context),
                icon: const Icon(Icons.location_on),
                label: Text("Stop: ${tripStop.dropdownEntry}"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.accomodation != null) {
                    widget.trip
                        .updateAccomodation(
                      widget.accomodation!,
                      tripStop,
                      accomodationType,
                      nameController.value.text,
                      selectedStartDate,
                      selectedEndDate,
                      const GeoPoint(28.543091, -80.665339),
                      null,
                    )
                        .then(
                      (value) {
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    widget.trip
                        .addAccomodation(
                      TripAccomodation(
                        nameController.value.text,
                        accomodationType,
                        selectedStartDate,
                        selectedEndDate,
                        const GeoPoint(28.543091, -80.665339),
                        tripStop.placeID,
                        confirmationSlug: null,
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
