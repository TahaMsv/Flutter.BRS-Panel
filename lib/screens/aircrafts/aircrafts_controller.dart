import 'package:flutter/material.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/navigation/route_names.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../core/util/handlers/success_handler.dart';
import 'aircrafts_state.dart';
import 'dialogs/add_aircraft_dialog.dart';
import 'usecases/add_aircraft_usecase.dart';

class AircraftsController extends MainController {
  late AircraftsState aircraftsState = ref.read(aircraftsProvider);

  void goAddAircraft() {
    nav.pushNamed(RouteNames.addFlight);
  }

  void openAddAirCraftDialog() {
    nav.dialog(const AddAirCraftDialog()).then((value) {
      aircraftsState.typeC.text = "";
      aircraftsState.registrationC.text = "";
      aircraftsState.binsC = [];
      aircraftsState.bins = [];
    });
  }

  void addBin() {
    aircraftsState.bins.add(Bin.empty());
    aircraftsState.binsC.add([TextEditingController(), TextEditingController()]);
    aircraftsState.setState();
  }

  void removeBin(int i) {
    aircraftsState.bins.removeAt(i);
    aircraftsState.binsC.removeAt(i);
    aircraftsState.setState();
  }

  addAirCraft() async {
    String al = aircraftsState.alC.text;
    String type = aircraftsState.typeC.text;
    String registration = aircraftsState.registrationC.text;
    List<Bin> bins = aircraftsState.bins;
    Aircraft aircraft = Aircraft(id: 0, al: al, registration: registration, aircraftType: type, bins: bins);
    AddAirCraftUseCase addAirCraftUseCase = AddAirCraftUseCase();
    AddAirCraftRequest addAirCraftRequest = AddAirCraftRequest(aircraft: aircraft);
    final fOrR = await addAirCraftUseCase(request: addAirCraftRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => addAirCraft()), (r) {
      final alP = ref.read(aircraftListProvider.notifier);
      alP.addAircraft(r.aircraft);
      nav.pop();
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Aircraft Added Successfully!"));
    });
  }
}
