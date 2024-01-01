import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/airport_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/navigation/route_names.dart';
import '../../core/util/confirm_operation.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../core/util/handlers/success_handler.dart';
import '../../initialize.dart';
import '../airport_carts/airport_carts_controller.dart';
import '../airport_carts/airport_carts_state.dart';
import '../airport_sections/airport_sections_controller.dart';
import '../airport_sections/airport_sections_state.dart';
import '../airport_setting/airport_setting_controller.dart';
import '../airport_setting/airport_setting_state.dart';
import 'airports_state.dart';
import 'dialogs/add_update_airport_dialog.dart';
import 'usecases/add_update_airport.dart';
import 'usecases/delete_airport.dart';
import 'usecases/get_airport_list.dart';

class AirportsController extends MainController {
  late AirportsState airportsState = ref.read(airportsProvider);

  /// View -------------------------------------------------------------------------------------------------------------

  Future<void> goCarts(DetailedAirport a) async {
    final selectedAirportP = ref.read(selectedAirportProvider.notifier);
    selectedAirportP.state = a;
    AirportCartsController airportCartsController = getIt<AirportCartsController>();
    final ulds = await airportCartsController.airportGetCarts();
    if (ulds != null) {
      nav.pushNamed(RouteNames.airportCarts);
    }
  }

  Future<void> goSections(DetailedAirport a) async {
    final selectedAirportP = ref.read(selectedAirportProvider.notifier);
    selectedAirportP.state = a;
    AirportSectionsController airportSectionsController = getIt<AirportSectionsController>();
    final sections = await airportSectionsController.airportGetSections();
    final airportSectionsP = ref.read(sectionsProvider.notifier);
    airportSectionsP.state = sections;
    airportSectionsController.initSelection();
    if (sections != null) nav.pushNamed(RouteNames.airportSections);
  }

  Future<void> goSetting(DetailedAirport a) async {
    final selectedAirportP = ref.read(selectedAirportProvider.notifier);
    selectedAirportP.state = a;
    AirportSettingController airportSettingController = getIt<AirportSettingController>();
    final setting = await airportSettingController.airportGetSetting();
    final airportSettingP = ref.read(settingProvider.notifier);
    airportSettingP.state = setting;
    if (setting != null) nav.pushNamed(RouteNames.airportSetting);
  }

  openAddUpdateAirportDialog({DetailedAirport? airport}) {
    airportsState.codeC.text = airport?.code ?? "";
    airportsState.cityC.text = airport?.cityName ?? "";
    nav.dialog(AddUpdateAirportDialog(airport: airport)).then((value) {
      airportsState.codeC.text = "";
      airportsState.cityC.text = "";
      airportsState.timeZone = null;
      airportsState.strTimeZone = null;
    });
  }

  /// Requests ---------------------------------------------------------------------------------------------------------

  addUpdateAirport(Airport? airport, bool isUpdate) async {
    AddUpdateAirportRequest addUpdateAirportRequest =
        AddUpdateAirportRequest(code: airportsState.codeC.text, cityName: airportsState.cityC.text, strTimeZone: airport?.strTimeZone, timeZone: airport?.timeZone, isUpdate: isUpdate);
    AddUpdateAirportUseCase addUpdateAirportUseCase = AddUpdateAirportUseCase();
    final fOrR = await addUpdateAirportUseCase(request: addUpdateAirportRequest);
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      final alP = ref.read(airportListProvider.notifier);
      if (isUpdate) {
        alP.updateAirportDetail(r.airport);
      } else {
        alP.addAirportDetail(r.airport);
      }
      nav.pop();
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Changes Done Successfully!"));
    });
  }

  deleteAirport(DetailedAirport airport) async {
    bool confirm = await ConfirmOperation.getConfirm(Operation(message: "You are Deleting Airport", title: "Are You Sure?", actions: ["Cancel", "Confirm"], type: OperationType.warning));
    if (!confirm) return;
    DeleteAirportRequest deleteAirportRequest = DeleteAirportRequest(code: airport.code);
    DeleteAirportUseCase deleteAirportUseCase = DeleteAirportUseCase();
    final fOrR = await deleteAirportUseCase(request: deleteAirportRequest);
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      final alP = ref.read(airportListProvider.notifier);
      alP.removeAirportDetail(airport.code);
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Airport is Removed Successfully!"));
    });
  }

  getAirports() async {
    GetAirportListRequest getAirportListRequest = GetAirportListRequest();
    GetAirportListUseCase getAirportListUseCase = GetAirportListUseCase();
    airportsState.loading = true;
    airportsState.setState();
    final fOrR = await getAirportListUseCase(request: getAirportListRequest);
    airportsState.loading = false;
    fOrR.fold((l) => FailureHandler.handle(l, retry: getAirports), (r) {
      final alP = ref.read(airportListProvider.notifier);
      alP.setAirportDetails(r.airports.airports);
    });
  }

  Future<void> retrieveAirportsScreenFromLocalStorage() async {
    getAirports();
  }

  /// Core -------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    getAirports();
    super.onInit();
  }
}
