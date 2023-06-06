import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'aircrafts_controller.dart';
import 'aircrafts_state.dart';

class AircraftsViewPhone extends StatelessWidget {
  final AircraftsController myAircraftsController;

  const AircraftsViewPhone({super.key, required this.myAircraftsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Aircrafts"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

