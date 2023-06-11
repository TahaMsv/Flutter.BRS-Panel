import 'package:brs_panel/core/classes/flight_details_class.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/flight_details/flight_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/flight_class.dart';
import '../../core/classes/user_class.dart';

final flightDetailsProvider = ChangeNotifierProvider<FlightDetailsState>((_) => FlightDetailsState());

class FlightDetailsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}

final expandedContainers = StateProvider<List<int>>((ref) => []);
final tagSearchProvider = StateProvider<String>((ref) => "");
final selectedPosInDetails = StateProvider<Position?>((ref) => null);



final selectedFlightProvider = StateProvider<Flight?>((ref) => null);
// final detailsProvider =StateNotifierProvider<FlightDetailsNotifier, FlightDetails?>((ref) => FlightDetailsNotifier(ref));
// final futureFlightDetailsNotifierProvider = FutureProvider((ref)async{
//   final details = await getIt<FlightDetailsController>().flightGetDetails(100);
//   return FlightDetailsNotifier(details);
// });

// class FlightDetailsNotifier extends StateNotifier<FlightDetails?> {
//   final StateNotifierProviderRef ref;
//   FlightDetailsNotifier(this.ref) : super(null);
//
//
//
//
//   void setFlightDetails(FlightDetails? fd) async{
//     state = fd;
//   }
//
//   // FlightDetailsNotifier(this.ref) : super(const AsyncValue.loading()) {
//   //   getFlightDetails(100);
//   // }
//   // void getFlightDetails(int id) async{
//   //   state = const AsyncValue.loading();
//   //   state = await AsyncValue.guard(() => getIt<FlightDetailsController>().flightGetDetails(100));
//   // }
// }

// final detailsProvider = StateNotifierProvider.autoDispose((ref) => FlightDetailsNotifier(const AsyncValue.data(null)));

final detailsProvider = FutureProvider.autoDispose<FlightDetails?>((ref){
  final sfP = ref.watch(selectedFlightProvider);
  if(sfP==null)return null;
  return getIt<FlightDetailsController>().flightGetDetails(sfP.id);
});

// final detailsProvider = FutureProvider.autoDispose<FlightDetailsNotifier>((ref){
//   final sfP = ref.watch(selectedFlightProvider);
//   // if(sfP==null)return null;
//   return FlightDetailsNotifier(null,id: sfP?.id);
//   // final sfP = ref.watch(selectedFlightProvider);
//   // if(sfP==null)return null;
//   // return getIt<FlightDetailsController>().flightGetDetails(sfP.id);
// });
//
//
// class FlightDetailsNotifier extends StateNotifier<FlightDetails?> {
//   FlightDetailsNotifier(super.state,{required int? id}){
//     if(id!=null) {
//       getDetails(id);
//     }
//   }
//
//   getDetails(id) async {
//     state = await getIt<FlightDetailsController>().flightGetDetails(id);
//   }
// }


