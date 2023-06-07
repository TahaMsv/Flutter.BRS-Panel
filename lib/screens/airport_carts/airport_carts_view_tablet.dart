import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'airport_carts_controller.dart';
import 'airport_carts_state.dart';

class AirportCartsViewTablet extends StatelessWidget {
  final AirportCartsController myAirportCartsController;

  const AirportCartsViewTablet({super.key, required this.myAirportCartsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("AirportCarts"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

