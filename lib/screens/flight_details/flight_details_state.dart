import 'package:brs_panel/core/classes/flight_details_class.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/flight_details/flight_details_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/pdf.dart';

import '../../core/classes/flight_class.dart';
import '../../core/classes/login_user_class.dart';

final flightDetailsProvider = ChangeNotifierProvider<FlightDetailsState>((_) => FlightDetailsState());

class FlightDetailsState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool showClearButton = false;

  ///bool loading = false;
}

final expandedAirportSectionsTag = StateProvider<List<int>>((ref) => []);
final expandedAirportSectionsContainer = StateProvider<List<int>>((ref) => []);
final expandedAirportSectionsBin = StateProvider<List<int>>((ref) => []);
final expandedTagDetailsDialog = StateProvider<List<int>>((ref) => []);
// final expandedContainers = StateProvider<List<int>>((ref) => []);
// final expandedBins = StateProvider<List<int>>((ref) => []);
final tagSearchProvider = StateProvider<String>((ref) => "");
final selectedPosInDetails = StateProvider<Position?>((ref) => null);

final selectedFlightProvider = StateProvider<Flight?>((ref) => null);
final pdfFormat = StateProvider<PdfPageFormat>((ref) => PdfPageFormat.a4);
final isPrintSettingEnable = StateProvider<bool>((ref) => false);
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

final detailsProvider = StateProvider<FlightDetails?>((ref) => null);

final refreshDetailsProvider = FutureProvider.autoDispose<FlightDetails?>((ref) async {
  final sfP = ref.watch(selectedFlightProvider);
  if (sfP == null) return null;
  final fdP = ref.watch(detailsProvider.notifier);
  FlightDetails? d = await getIt<FlightDetailsController>().flightGetDetails(sfP.id);
  fdP.state = d;
  return fdP.state;
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
