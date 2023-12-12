import 'package:flutter/cupertino.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_class.dart';

final airportsProvider = ChangeNotifierProvider<AirportsState>((_) => AirportsState());

class AirportsState extends ChangeNotifier {
  void setState() => notifyListeners();

  final TextEditingController codeC = TextEditingController();
  final TextEditingController cityC = TextEditingController();
  int? timeZone;
  String? strTimeZone;
  bool loading = false;
}

final airportsSearchProvider = StateProvider<String>((ref) => '');
final filteredAirportListProvider = Provider<List<DetailedAirport>>((ref) {
  final airports = ref.watch(airportListProvider);
  final searchFilter = ref.watch(airportsSearchProvider);
  return airports.where((f) => f.validateSearch(searchFilter)).toList();
});

final airportListProvider = StateNotifierProvider<AirportDetailListNotifier, List<DetailedAirport>>((ref) {
  return AirportDetailListNotifier(ref);
});

class AirportDetailListNotifier extends StateNotifier<List<DetailedAirport>> {
  final StateNotifierProviderRef ref;

  AirportDetailListNotifier(this.ref) : super([]);

  void addAirportDetail(DetailedAirport airport) {
    state = [...state, airport];
  }

  void updateAirportDetail(DetailedAirport airport) {
    List<DetailedAirport> airports = [...state];
    DetailedAirport? da = airports.firstWhereOrNull((a) => a.code == airport.code);
    if (da == null) return;
    airports[airports.indexOf(da)] = airport;
    state = airports;
  }

  void removeAirportDetail(String code) {
    state = state.where((element) => element.code != code).toList();
  }

  void setAirportDetails(List<DetailedAirport> fl) {
    state = fl;
  }
}
