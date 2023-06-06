import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/user_class.dart';

final airlinesProvider = ChangeNotifierProvider<AirlinesState>((_) => AirlinesState());

class AirlinesState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;
}

final airlineListProvider = StateNotifierProvider<AirlineListNotifier, List<Airline>>((ref) => AirlineListNotifier(ref));

final airlineSearchProvider = StateProvider<String>((ref) => '');
final filteredAirlineListProvider = Provider<List<Airline>>((ref) {
  // final airlines = ref.watch(airlineListProvider);
  final airlines = BasicClass.systemSetting.airlineList;
  final searchFilter = ref.watch(airlineSearchProvider);
  return airlines
      .where(
        (f) => f.validateSearch(searchFilter),
      )
      .toList();
});

class AirlineListNotifier extends StateNotifier<List<Airline>> {
  final StateNotifierProviderRef ref;

  AirlineListNotifier(this.ref) : super([]);

  void addAirline(Airline airline) {
    state = [...state, airline];
  }

  void removeAirline(String code) {
    state = state.where((element) => element.al != code).toList();
  }

  void setAirlines(List<Airline> fl) {
    state = fl;
  }
}

///final userProvider = StateProvider<User?>((ref) => null);
