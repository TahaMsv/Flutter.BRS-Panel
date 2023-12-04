import 'package:brs_panel/core/classes/login_user_class.dart';
import 'package:brs_panel/screens/aircrafts/dialogs/add_aircraft_dialog.dart';
import 'package:flutter/material.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/navigation/route_names.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'aircrafts_state.dart';

class AircraftsController extends MainController {
  late AircraftsState aircraftsState = ref.read(aircraftsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  void goAddAircraft() {
    nav.pushNamed(RouteNames.addFlight);
  }

  void openAddAirCraftDialog() {
    nav.dialog(AddAirCraftDialog());
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

  void addAirCraft() {
    String al = aircraftsState.alC.text;
    String type = aircraftsState.typeC.text;
    String registration = aircraftsState.registrationC.text;
    List<Bin> bins = aircraftsState.bins;

    if (al.isEmpty) {
      FailureHandler.handle(ValidationFailure(code: 1, msg: "Al should not be empty", traceMsg: ""));
    }
    if (type.isEmpty) {
      FailureHandler.handle(ValidationFailure(code: 1, msg: "Type should not be empty", traceMsg: ""));
    }
    if (registration.isEmpty) {
      FailureHandler.handle(ValidationFailure(code: 1, msg: "Registration should not be empty", traceMsg: ""));
    }
    Aircraft aircraft = Aircraft(id: 0, al: al, registration: registration, aircraftType: type, bins: bins);
    //todo
  }
}
