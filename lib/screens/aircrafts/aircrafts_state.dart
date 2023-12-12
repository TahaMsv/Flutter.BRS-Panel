import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/util/basic_class.dart';

final aircraftsProvider = ChangeNotifierProvider<AircraftsState>((_) => AircraftsState());

class AircraftsState extends ChangeNotifier {
  void setState() => notifyListeners();

  ///bool loading = false;
  List<Bin> bins = [];
  TextEditingController alC = TextEditingController(text: BasicClass.userInfo.userSettings.al);
  TextEditingController typeC = TextEditingController();
  TextEditingController registrationC = TextEditingController();
  List<List<TextEditingController>> binsC = [];
}

final aircraftSearchProvider = StateProvider<String>((ref) => '');
final filteredAircraftListProvider = Provider<List<Aircraft>>((ref) {
  final aircrafts = ref.watch(aircraftListProvider);
  print("filteredAircraftListProvider ${aircrafts.length}");
  final searchFilter = ref.watch(aircraftSearchProvider);
  return aircrafts.where((f) => f.validateSearch(searchFilter)).toList();
});

final aircraftListProvider = StateNotifierProvider<AircraftListNotifier, List<Aircraft>>((ref) {
  return AircraftListNotifier(ref);
});

class AircraftListNotifier extends StateNotifier<List<Aircraft>> {
  final StateNotifierProviderRef ref;

  AircraftListNotifier(this.ref) : super(BasicClass.systemSetting.aircraftList);

  void addAircraft(Aircraft aircraft) {
    state = [...state, aircraft];
  }

  void updateAircraft(Aircraft aircraft) {
    List<Aircraft> aircrafts = [...state];
    Aircraft? a = aircrafts.firstWhereOrNull((a) => a.id == aircraft.id);
    if (a == null) return;
    aircrafts[aircrafts.indexOf(a)] = aircraft;
    state = aircrafts;
  }

  void removeAircraft(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  void setAircrafts(List<Aircraft> fl) {
    state = fl;
  }
}
