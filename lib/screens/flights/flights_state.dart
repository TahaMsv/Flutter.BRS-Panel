import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/enums/flight_type_filter_enum.dart';

final flightsProvider = ChangeNotifierProvider<FlightsState>((_) => FlightsState());

class FlightsState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool loadingFlights = false;
  List<int> containerAssignButtonLoading = [];
}

final flightListProvider = StateNotifierProvider<FlightListNotifier, List<Flight>>((ref) => FlightListNotifier(ref));

final flightSearchProvider = StateProvider<String>((ref) => '');
final flightDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final flightsShowFiltersProvider = StateProvider<bool>((ref) => true);
final flightActionHandlingProvider = StateProvider<List<int>>((ref) => []);
final flightTypeFilterProvider = StateProvider<FlightTypeFilter>((ref) => FlightTypeFilter.departure);
final flightAirportFilterProvider = StateProvider<Airport?>((ref) => null);
final flightAirlineFilterProvider = StateProvider<String?>((ref) => null);

final filteredFlightListProvider = Provider<List<Flight>>((ref) {
  final flights = ref.watch(flightListProvider);
  final typeFilter = ref.watch(flightTypeFilterProvider);
  final alFilter = ref.watch(flightAirlineFilterProvider);
  final apFilter = ref.watch(flightAirportFilterProvider);
  final searchFilter = ref.watch(flightSearchProvider);
  return flights
      .where(
        (f) => f.validateType(typeFilter) && f.validateSearch(searchFilter) && f.validateAirline(alFilter) && f.validateAirport(apFilter),
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

  void setFlights(List<Flight> fl) {
    state = fl;
  }
}
