import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'add_flight_controller.dart';
import 'add_flight_state.dart';

class AddFlightViewPhone extends StatelessWidget {
  final AddFlightController myAddFlightController;

  const AddFlightViewPhone({super.key, required this.myAddFlightController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("AddFlight"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

