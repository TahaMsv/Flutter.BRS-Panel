import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/flight_class.dart';
import '../../core/enums/flight_type_filter_enum.dart';

final flightsProvider = ChangeNotifierProvider<FlightsState>((_) => FlightsState());

class FlightsState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool loadingFlights = false;

}


final flightListProvider = StateNotifierProvider<FlightListNotifier, List<Flight>>((ref) => FlightListNotifier(ref));

final flightSearchProvider = StateProvider<String>((ref) => '');
final flightDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final flightsShowFiltersProvider = StateProvider<bool>((ref) => false);
final flightTypeFilterProvider = StateProvider<FlightTypeFilter>((ref) => FlightTypeFilter.departure);

final filteredFlightListProvider = Provider<List<Flight>>((ref){
  final flights = ref.watch(flightListProvider);
  final typeFilter = ref.watch(flightTypeFilterProvider);
  final searchFilter = ref.watch(flightSearchProvider);
  return flights
      .where(
        (f) => f.validateType(typeFilter) && f.validateSearch(searchFilter),
  )
      .toList();
});

class FlightListNotifier extends StateNotifier<List<Flight>> {
  final StateNotifierProviderRef ref;

  FlightListNotifier(this.ref) : super([]);

  void addFlight(Flight flight) {
    state = [...state, flight];
  }

  void removeFlight(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  void setFlights(List<Flight> fl){
    state= fl;
  }

}

