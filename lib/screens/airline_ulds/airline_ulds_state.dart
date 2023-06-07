import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/airline_uld_class.dart';

final airlineUldsProvider = ChangeNotifierProvider<AirlineUldsState>((_) => AirlineUldsState());

class AirlineUldsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}

final uldListProvider = StateNotifierProvider<AirlineUldListNotifier, List<AirlineUld>>((ref) => AirlineUldListNotifier(ref));

final uldSearchProvider = StateProvider<String>((ref) => '');


final filteredUldListProvider = Provider<List<AirlineUld>>((ref){
  final ulds = ref.watch(uldListProvider);
  final searchFilter = ref.watch(uldSearchProvider);
  return ulds
      .where(
        (f) => f.validateSearch(searchFilter),
  )
      .toList();
});

class AirlineUldListNotifier extends StateNotifier<List<AirlineUld>> {
  final StateNotifierProviderRef ref;

  AirlineUldListNotifier(this.ref) : super([]);

  void addAirlineUld(AirlineUld uld) {
    state = [...state, uld];
  }

  void removeAirlineUld(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  void setAirlineUlds(List<AirlineUld> fl){
    state= fl;
  }

}
