import 'package:flutter/material.dart';
import 'airport_setting_controller.dart';

class AirportSettingViewPhone extends StatelessWidget {
  final AirportSettingController myAirportSettingController;

  const AirportSettingViewPhone({super.key, required this.myAirportSettingController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AirportSetting"),
      ),
      backgroundColor: Colors.black54,
      body: const Column(children: []),
    );
  }
}
