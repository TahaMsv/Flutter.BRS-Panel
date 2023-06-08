import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/airport_cart_class.dart';
import '../../core/classes/user_class.dart';

final airportCartsProvider = ChangeNotifierProvider<AirportCartsState>((_) => AirportCartsState());

class AirportCartsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;
}

final cartListProvider = StateNotifierProvider<AirportCartListNotifier, List<AirportCart>>((ref) => AirportCartListNotifier(ref));

final cartSearchProvider = StateProvider<String>((ref) => '');
final selectedAirportProvider = StateProvider<Airport?>((ref) => null);

final filteredCartListProvider = Provider<List<AirportCart>>((ref) {
  final carts = ref.watch(cartListProvider);
  final searchFilter = ref.watch(cartSearchProvider);
  return carts.where((f) => f.validateSearch(searchFilter)).toList();
});

class AirportCartListNotifier extends StateNotifier<List<AirportCart>> {
  final StateNotifierProviderRef ref;

  AirportCartListNotifier(this.ref) : super([]);

  void addAirportCart(AirportCart cart) {
    state = [...state, cart];
  }

  void removeAirportCart(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  void setAirportCarts(List<AirportCart> fl) {
    print("Setting ${fl.length}");
    state = fl;
  }

  void updateCart(AirportCart u) {
    state = state.map((e) {
      if (e.id == u.id) {
        return u;
      } else {
        return e;
      }
    }).toList();
  }
}
