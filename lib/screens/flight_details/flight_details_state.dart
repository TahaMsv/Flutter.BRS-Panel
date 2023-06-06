import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flight_detailsProvider = ChangeNotifierProvider<FlightDetailsState>((_) => FlightDetailsState());

class FlightDetailsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}


///final userProvider = StateProvider<User?>((ref) => null);
