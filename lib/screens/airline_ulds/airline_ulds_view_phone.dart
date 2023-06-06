import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'airline_ulds_controller.dart';
import 'airline_ulds_state.dart';

class AirlineUldsViewPhone extends StatelessWidget {
  final AirlineUldsController myAirlineUldsController;

  const AirlineUldsViewPhone({super.key, required this.myAirlineUldsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("AirlineUlds"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

