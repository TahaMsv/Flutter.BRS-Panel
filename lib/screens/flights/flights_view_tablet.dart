import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'flights_controller.dart';
import 'flights_state.dart';

class FlightsViewTablet extends StatelessWidget {
  final FlightsController myFlightsController;

  const FlightsViewTablet({super.key, required this.myFlightsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Flights"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

