import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final int index;
  const TripCard(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 41, 41, 41),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          onTap: () {
            debugPrint("test");
          },
          child: Center(
            child: Text(
              'Trip #$index',
              style: const TextStyle(fontSize: 30.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
