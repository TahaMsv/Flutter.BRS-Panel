import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/login_user_class.dart';
import '../../core/util/basic_class.dart';

final aircraftsProvider = ChangeNotifierProvider<AircraftsState>((_) => AircraftsState());

class AircraftsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}

final aircraftSearchProvider = StateProvider<String>((ref) => '');
final filteredAircraftListProvider = Provider<List<Aircraft>>((ref) {
  // final aircrafts = ref.watch(aircraftListProvider);
  final aircrafts = BasicClass.systemSetting.aircraftList;
  print("filteredAircraftListProvider ${aircrafts.length}");
  final searchFilter = ref.watch(aircraftSearchProvider);

  return aircrafts
      .where(
        (f) => f.validateSearch(searchFilter),
  )
      .toList();
});

class AircraftListNotifier extends StateNotifier<List<Aircraft>> {
  final StateNotifierProviderRef ref;

  AircraftListNotifier(this.ref) : super([]);

  void addAircraft(Aircraft aircraft) {
    state = [...state, aircraft];
  }

  void removeAircraft(String code) {
    state = state.where((element) => element.al != code).toList();
  }

  void setAircrafts(List<Aircraft> fl) {
    state = fl;
  }
}
