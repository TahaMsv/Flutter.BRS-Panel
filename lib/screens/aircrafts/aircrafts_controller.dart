import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/material.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/navigation/route_names.dart';
import '../../core/util/confirm_operation.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../core/util/handlers/success_handler.dart';
import 'aircrafts_state.dart';
import 'dialogs/add_aircraft_dialog.dart';
import 'usecases/add_aircraft_usecase.dart';
import 'usecases/delete_aircraft.dart';
import 'usecases/get_aircraft_list.dart';

class AircraftsController extends MainController {
  late AircraftsState aircraftsState = ref.read(aircraftsProvider);

  void goAddAircraft() {
    nav.pushNamed(RouteNames.addFlight);
  }

  void openAddUpdateAirCraftDialog({Aircraft? aircraft}) {
    aircraftsState.typeC.text = aircraft?.aircraftType ?? "";
    aircraftsState.registrationC.text = aircraft?.registration ?? "";
    aircraftsState.bins = aircraft?.bins ?? [];
    aircraftsState.binsC = aircraft?.bins.map((e) => [TextEditingController(text: e.compartment), TextEditingController(text: e.binNumber)]).toList() ?? [];
    nav.dialog(AddUpdateAirCraftDialog(aircraft: aircraft)).then((value) {
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

  getAircrafts() async {
    GetAircraftListRequest getAircraftListRequest = GetAircraftListRequest(al: BasicClass.userSetting.al);
    GetAircraftListUseCase getAircraftListUseCase = GetAircraftListUseCase();
    aircraftsState.loading = true;
    aircraftsState.setState();
    final fOrR = await getAircraftListUseCase(request: getAircraftListRequest);
    aircraftsState.loading = false;
    fOrR.fold((l) => FailureHandler.handle(l, retry: getAircrafts), (r) {
      final alP = ref.read(aircraftListProvider.notifier);
      alP.setAircrafts(r.aircrafts);
    });
  }

  addUpdateAirCraft({Aircraft? aircraft, required bool isUpdate}) async {
    String al = aircraftsState.alC.text;
    String type = aircraftsState.typeC.text;
    String registration = aircraftsState.registrationC.text;
    List<Bin> bins = aircraftsState.bins;
    Aircraft temp = (aircraft ?? Aircraft.empty()).copyWith(al: al, registration: registration, aircraftType: type, bins: bins);
    AddAirCraftUseCase addAirCraftUseCase = AddAirCraftUseCase();
    AddAirCraftRequest addAirCraftRequest = AddAirCraftRequest(aircraft: temp);
    final fOrR = await addAirCraftUseCase(request: addAirCraftRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => addUpdateAirCraft(aircraft: aircraft, isUpdate: isUpdate)), (r) {
      final alP = ref.read(aircraftListProvider.notifier);
      if (isUpdate) {
        alP.updateAircraft(r.aircraft);
      } else {
        alP.addAircraft(r.aircraft);
      }
      nav.pop();
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Changes Done Successfully!"));
    });
  }

  deleteAircraft(Aircraft f) async {
    bool confirm = await ConfirmOperation.getConfirm(Operation(message: "You are Deleting Aircraft", title: "Are You Sure?", actions: ["Cancel", "Confirm"], type: OperationType.warning));
    if (!confirm) return;
    DeleteAircraftRequest deleteAircraftRequest = DeleteAircraftRequest(id: f.id);
    DeleteAircraftUseCase deleteAircraftUseCase = DeleteAircraftUseCase();
    final fOrR = await deleteAircraftUseCase(request: deleteAircraftRequest);
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      final alP = ref.read(aircraftListProvider.notifier);
      alP.removeAircraft(f.id);
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Aircraft is Removed Successfully!"));
    });
  }

  Future<void> retrieveAirCraftsScreenFromLocalStorage() async {
    getAircrafts();
  }

  @override
  void onInit() {
    getAircrafts();
    super.onInit();
  }
}
