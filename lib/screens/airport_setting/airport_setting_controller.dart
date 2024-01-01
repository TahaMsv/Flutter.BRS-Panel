import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/airport_class.dart';
import '../../core/classes/airport_setting_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../airport_carts/airport_carts_state.dart';
import 'airport_setting_state.dart';
import 'usecase/airport_get_setting_usecase.dart';

class AirportSettingController extends MainController {
  late AirportSettingState airportSettingState = ref.read(airportSettingProvider);

  /// View Related -----------------------------------------------------------------------------------------------------

  /// Requests ---------------------------------------------------------------------------------------------------------

  Future<AirportSetting?> airportGetSetting() async {
    DetailedAirport? sapP = ref.read(selectedAirportProvider);
    if (sapP == null) return null;
    AirportSetting? setting;
    AirportGetSettingUseCase airportGetSettingUseCase = AirportGetSettingUseCase();
    AirportGetSettingRequest airportGetSettingRequest = AirportGetSettingRequest(airportCode: sapP.code);
    final fOrR = await airportGetSettingUseCase(request: airportGetSettingRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportGetSetting()), (r) {
      setting = r.airportSetting;
    });
    return setting;
  }

  updateSettingRequest() {}

  /// Core -------------------------------------------------------------------------------------------------------------
}
