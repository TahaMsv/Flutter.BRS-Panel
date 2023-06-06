import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final airline_uldsProvider = ChangeNotifierProvider<AirlineUldsState>((_) => AirlineUldsState());

class AirlineUldsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}


///final userProvider = StateProvider<User?>((ref) => null);
