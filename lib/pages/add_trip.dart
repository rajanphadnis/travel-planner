import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/classes/trip.dart';

class AddTrip extends StatefulWidget {
  final Trip? trip;
  const AddTrip({super.key, this.trip});

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  DateTime selectedStartDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final TextEditingController nameController = TextEditingController();

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
    if (widget.trip != null) {
      selectedStartDate = widget.trip!.tripStartTime;
      nameController.value = TextEditingValue(text: widget.trip!.name);
    }
  }

  Future<void> _confirmDeleteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Trip?"),
          content: Text(
              "Please confirm you'd like to delete trip called '${nameController.value.text}'"),
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
                widget.trip!.deleteTrip().then((value) {
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
        title: Text(widget.trip != null ? "Edit Trip" : "Add Trip"),
        actions: [
          widget.trip != null
              ? IconButton(
                  onPressed: () {
                    _confirmDeleteDialog(context).then((value) {
                      while (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  icon: const Icon(Icons.delete),
                )
              : Container(),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TextField(
            controller: nameController,
          ),
          ElevatedButton.icon(
            onPressed: () => _selectStartDate(context),
            icon: const Icon(Icons.calendar_today),
            label: Text(
                "Start Date: ${selectedStartDate.toLocal().toString().split(" ")[0]}"),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          onPressed: () {
            if (widget.trip != null) {
              widget.trip!
                  .updateTrip(nameController.value.text, selectedStartDate)
                  .then((value) {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
            } else {
              final db = FirebaseFirestore.instance;
              final user = FirebaseAuth.instance.currentUser!;
              db.collection("users/${user.uid}/activeTrips").add({
                "name": nameController.value.text,
                "startTime": selectedStartDate,
                "trip": [],
              }).then((value) {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
            }
          },
          child: const Text("Save")),
    );
  }
}
