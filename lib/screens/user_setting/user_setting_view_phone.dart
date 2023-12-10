import 'package:flutter/material.dart';
import 'user_setting_controller.dart';

class UserSettingViewPhone extends StatelessWidget {
  final UserSettingController myUserSettingController;

  const UserSettingViewPhone({super.key, required this.myUserSettingController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("UserSetting")),
        backgroundColor: Colors.black54,
        body: const Column(children: []));
  }
}
