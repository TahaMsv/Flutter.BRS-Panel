import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'airlines_controller.dart';
import 'airlines_state.dart';

class AirlinesViewTablet extends StatelessWidget {
  final AirlinesController myAirlinesController;

  const AirlinesViewTablet({super.key, required this.myAirlinesController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Airlines"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

