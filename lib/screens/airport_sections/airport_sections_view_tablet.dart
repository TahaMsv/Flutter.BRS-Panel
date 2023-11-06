import 'package:flutter/material.dart';
import 'airport_sections_controller.dart';

class AirportSectionsViewTablet extends StatelessWidget {
  final AirportSectionsController myAirportSectionsController;

  const AirportSectionsViewTablet({super.key, required this.myAirportSectionsController});

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
