import 'package:flutter/material.dart';
import 'airport_sections_controller.dart';

class AirportSectionsViewPhone extends StatelessWidget {
  final AirportSectionsController myAirportSectionsController;

  const AirportSectionsViewPhone({super.key, required this.myAirportSectionsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AirportSections"),
      ),
      backgroundColor: Colors.black54,
      body: const Column(children: []),
    );
  }
}
