import 'package:flutter/material.dart';
import '../../core/util/basic_class.dart';
import 'users_controller.dart';
import 'users_state.dart';

class UsersViewPhone extends StatelessWidget {
  final UsersController myUsersController;

  const UsersViewPhone({super.key, required this.myUsersController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Users"),),
        backgroundColor: Colors.black54,
        body: Column(children: [

        ],));
  }
}

