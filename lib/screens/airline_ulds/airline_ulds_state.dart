import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/airline_uld_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/user_class.dart';

final airlineUldsProvider = ChangeNotifierProvider<AirlineUldsState>((_) => AirlineUldsState());

class AirlineUldsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;

}

final selectedAirlineProvider = StateProvider<Airline?>((ref) => BasicClass.getAirlineByCode(BasicClass.userSetting.al));

final uldListProvider = StateNotifierProvider<AirlineUldListNotifier, List<TagContainer>>((ref) => AirlineUldListNotifier(ref));

final uldSearchProvider = StateProvider<String>((ref) => '');


final filteredUldListProvider = Provider<List<TagContainer>>((ref){
  final ulds = ref.watch(uldListProvider);
  final searchFilter = ref.watch(uldSearchProvider);
  return ulds
      .where(
        (f) => f.validateSearch(searchFilter),
  )
      .toList();
});

class AirlineUldListNotifier extends StateNotifier<List<TagContainer>> {
  final StateNotifierProviderRef ref;

  AirlineUldListNotifier(this.ref) : super([]);

  void addAirlineUld(TagContainer uld) {
    state = [...state, uld];
  }

  void removeAirlineUld(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  void updateUld(TagContainer u) {
    state = state.map((e) {
      if (e.id == u.id) {
        return u;
      } else {
        return e;
      }
    }).toList();
  }

  void updateUldList(List<TagContainer> ul) {
    state = state.map((e) {
      if (ul.map((u) => u.id).contains(e.id)) {
        return ul.firstWhere((u) => u.id==e.id);
      } else {
        return e;
      }
    }).toList();
  }

  void setAirlineUlds(List<TagContainer> fl){
    state= fl;
  }

}
