import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/stop.dart';
import 'package:travel_planner/classes/trip.dart';

class AddStop extends StatefulWidget {
  final Trip trip;
  final TripStop? stop;
  const AddStop(this.trip, {super.key, this.stop});

  @override
  State<AddStop> createState() => _AddStopState();
}

class _AddStopState extends State<AddStop> {
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
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

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
    if (widget.stop != null) {
      selectedStartDate = widget.stop!.startTime;
      selectedEndDate = widget.stop!.endTime;
      nameController.value = TextEditingValue(text: widget.stop!.name);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Stop"),
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
                    "Start Date: ${selectedStartDate.toLocal().toString().split(" ")[0]}"),
              ),
              ElevatedButton.icon(
                onPressed: () => _selectEndDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                    "End Date: ${selectedEndDate.toLocal().toString().split(" ")[0]}"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.stop != null) {
                    widget.trip
                        .updateStop(
                      widget.stop!.placeID,
                      nameController.value.text,
                      selectedStartDate,
                      selectedEndDate,
                      const GeoPoint(28.543091, -80.665339),
                    )
                        .then(
                      (value) {
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    widget.trip
                        .addStop(
                      nameController.value.text,
                      selectedStartDate,
                      selectedEndDate,
                      const GeoPoint(28.543091, -80.665339),
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
