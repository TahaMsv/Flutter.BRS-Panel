import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/login_user_class.dart';

final airlinesProvider = ChangeNotifierProvider<AirlinesState>((_) => AirlinesState());

class AirlinesState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;
}

// final airlineListProvider = StateNotifierProvider<AirlineListNotifier, List<String>>((ref) => AirlineListNotifier(ref));
// final airlineListProvider = StateNotifier<List<String>>((ref) => []);

final airlineSearchProvider = StateProvider<String>((ref) => '');
// final airlineListProvider = StateProvider<List<String>>((ref) => []);
final filteredAirlineListProvider = Provider<List<String>>((ref) {
  // final airlines = ref.watch(airlineListProvider);
  final airlines = ref.watch(airlineListProvider);
  final searchFilter = ref.watch(airlineSearchProvider);
  return airlines
      .where(
        (f) =>  searchFilter.trim().isEmpty || f.toLowerCase().contains(searchFilter.toLowerCase()),
      )
      .toList();
});

final airlineListProvider = StateNotifierProvider<AirlinesListNotifier, List<String>>((ref) {
  return AirlinesListNotifier(ref);
});

class AirlinesListNotifier extends StateNotifier<List<String>> {
  final StateNotifierProviderRef ref;

  AirlinesListNotifier(this.ref) : super(BasicClass.airlineList);

  void setAirlines(List<String> al) {
    state = al;
  }
}



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
