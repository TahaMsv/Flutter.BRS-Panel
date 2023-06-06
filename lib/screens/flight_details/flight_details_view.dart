import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'flight_details_controller.dart';
import 'flight_details_state.dart';

class FlightDetailsView extends StatelessWidget {

  const FlightDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar:MyAppBar(),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

