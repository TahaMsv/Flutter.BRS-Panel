import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final usersProvider = ChangeNotifierProvider<UsersState>((_) => UsersState());

class UsersState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}


///final userProvider = StateProvider<User?>((ref) => null);
