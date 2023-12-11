import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'special_reports_controller.dart';
import 'special_reports_state.dart';

class SpecialReportsViewTablet extends StatelessWidget {
  final SpecialReportsController mySpecialReportsController;

  const SpecialReportsViewTablet({super.key, required this.mySpecialReportsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("SpecialReports"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

