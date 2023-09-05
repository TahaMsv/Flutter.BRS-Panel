import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'bsm_controller.dart';
import 'bsm_state.dart';

class BsmViewTablet extends StatelessWidget {
  final BsmController myBsmController;

  const BsmViewTablet({super.key, required this.myBsmController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Bsm"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

