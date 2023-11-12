import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/login_user_class.dart';
import '../../core/util/basic_class.dart';

final airportsProvider = ChangeNotifierProvider<AirportsState>((_) => AirportsState());

class AirportsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}


final airportsSearchProvider = StateProvider<String>((ref) => '');
final filteredAirportListProvider = Provider<List<Airport>>((ref) {
  // final airports = ref.watch(airportListProvider);
  final airports = BasicClass.systemSetting.airportList;
  final searchFilter = ref.watch(airportsSearchProvider);
  return airports
      .where(
        (f) => f.validateSearch(searchFilter),
  )
      .toList();
});

class AirportListNotifier extends StateNotifier<List<Airport>> {
  final StateNotifierProviderRef ref;

  AirportListNotifier(this.ref) : super([]);

  void addAirport(Airport airport) {
    state = [...state, airport];
  }

  void removeAirport(String code) {
    state = state.where((element) => element.code != code).toList();
  }

  void setAirports(List<Airport> fl) {
    state = fl;
  }
}
