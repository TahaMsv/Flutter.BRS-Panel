import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'airports_controller.dart';
import 'airports_state.dart';

class AirportsViewTablet extends StatelessWidget {
  final AirportsController myAirportsController;

  const AirportsViewTablet({super.key, required this.myAirportsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Airports"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

