import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'flight_details_controller.dart';
import 'flight_details_state.dart';

class FlightDetailsViewTablet extends StatelessWidget {
  final FlightDetailsController myFlightDetailsController;

  const FlightDetailsViewTablet({super.key, required this.myFlightDetailsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("FlightDetails"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

