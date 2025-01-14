import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/classes/server_class.dart';

final loginProvider = ChangeNotifierProvider<LoginState>((_) => LoginState());

class LoginState extends ChangeNotifier {
  void setState() => notifyListeners();

  LoginUser? admin;
  TextEditingController usernameC= TextEditingController();
  TextEditingController passwordC= TextEditingController();
  TextEditingController alC= TextEditingController();

  bool loadingLogin = false;

}


final userProvider = StateProvider<LoginUser?>((ref) => null);
final adminProvider = StateProvider<LoginUser?>((ref) => null);
final selectedServer = StateProvider<Server?>((ref) => null);
final versionProvider = StateProvider<String?>((ref) => null);
