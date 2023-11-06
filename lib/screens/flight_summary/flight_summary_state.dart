import 'package:brs_panel/core/classes/flight_summary_class.dart';
import 'package:brs_panel/screens/flight_summary/flight_summary_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../initialize.dart';
import '../flight_details/flight_details_state.dart';

final flightSummaryStateProvider = ChangeNotifierProvider<FlightSummaryState>((_) => FlightSummaryState());

class FlightSummaryState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}

final flightSummaryProvider = FutureProvider.autoDispose<FlightSummary?>((ref){
  final sfP = ref.watch(selectedFlightProvider);
  if(sfP==null)return null;
  return getIt<FlightSummaryController>().flightGetSummary(sfP.id);
});


///final userProvider = StateProvider<User?>((ref) => null);
