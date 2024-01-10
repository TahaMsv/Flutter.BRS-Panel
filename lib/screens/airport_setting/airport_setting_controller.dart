import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/airport_class.dart';
import '../../core/classes/airport_setting_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../core/util/handlers/success_handler.dart';
import '../airport_carts/airport_carts_state.dart';
import 'airport_setting_state.dart';
import 'usecase/airport_get_setting_usecase.dart';
import 'usecase/airport_update_setting_usecase.dart';

class AirportSettingController extends MainController {
  late AirportSettingState airportSettingState = ref.read(airportSettingProvider);

  /// View Related -----------------------------------------------------------------------------------------------------

  addHandling() {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    List<Setting> temp = as.defaultSetting.map((e) => Setting(id: null, key: e.key, type: e.type, value: e.type == 'bool' ? false : null)).toList();
    as.handlingsOverride.add(HandlingsOverride(handlingId: null, setting: temp, airlineOverride: []));
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

  removeHandling(HandlingsOverride ho) {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    as.handlingsOverride.remove(ho);
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

  addAirline(HandlingsOverride ho) {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    int i = as.handlingsOverride.indexOf(ho);
    List<Setting> temp = as.defaultSetting.map((e) => Setting(id: null, key: e.key, type: e.type, value: e.type == 'bool' ? false : null)).toList();
    ho.airlineOverride.add(AirlineOverride(al: "", setting: temp));
    as.handlingsOverride[i] = ho;
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

  removeAirline(AirlineOverride ao, HandlingsOverride ho) {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    int i = as.handlingsOverride.indexOf(ho);
    ho.airlineOverride.remove(ao);
    as.handlingsOverride[i] = ho;
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

  onChangeDefaultSetting(value, Setting s) {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    int i = as.defaultSetting.indexOf(s);
    as.defaultSetting[i].value = value;
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

  onChangeHOSetting(value, Setting s, HandlingsOverride ho) {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    int i = as.handlingsOverride.indexOf(ho);
    int ii = as.handlingsOverride[i].setting.indexOf(s);
    as.handlingsOverride[i].setting[ii].value = value;
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

  changeAOSetting(value, Setting s, AirlineOverride ao, HandlingsOverride ho) {
    final updatingDataP = ref.read(updateDataProvider.notifier);
    AirportSetting as = updatingDataP.state ?? AirportSetting.empty();
    int i = as.handlingsOverride.indexOf(ho);
    int ii = as.handlingsOverride[i].airlineOverride.indexOf(ao);
    int iii = as.handlingsOverride[i].airlineOverride[ii].setting.indexOf(s);
    as.handlingsOverride[i].airlineOverride[ii].setting[iii].value = value;
    updatingDataP.update((state) => as);
    airportSettingState.setState();
  }

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

  updateSettingRequest() async {
    final settingP = ref.read(settingProvider.notifier);
    final updatingDataP = ref.read(updateDataProvider.notifier);
    final as = updatingDataP.state ?? AirportSetting.empty();
    AirportUpdateSettingUseCase airportUpdateSettingUseCase = AirportUpdateSettingUseCase();
    AirportUpdateSettingRequest airportUpdateSettingRequest = AirportUpdateSettingRequest(airportSetting: as);
    final fOrR = await airportUpdateSettingUseCase(request: airportUpdateSettingRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => updateSettingRequest()), (r) {
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Changes Saved Successfully!"));
      settingP.state = updatingDataP.state;
      airportSettingState.setState();
    });
  }

  /// Core -------------------------------------------------------------------------------------------------------------

  initialize() {
    AirportSetting? airportSetting = ref.read(settingProvider.notifier).state;
    final updatingData = ref.read(updateDataProvider.notifier);
    updatingData.update((state) => airportSetting);
    airportSetting?.defaultSetting.forEach((s) {
      if (s.value == null && s.type == 'bool') {
        onChangeDefaultSetting(false, s);
      } else {
        if (s.type == 'int') onChangeDefaultSetting(int.tryParse(s.value), s);
        if (s.type == 'bool' && s.value is String) onChangeDefaultSetting(bool.tryParse(s.value), s);
      }
    });
    airportSetting?.defaultSetting.sort((a, b) => b.type.compareTo(a.type));
    airportSetting?.handlingsOverride.forEach((ho) {
      ho.setting.forEach((s) {
        if (s.value == null && s.type == 'bool') {
          onChangeHOSetting(false, s, ho);
        } else {
          if (s.type == 'int') onChangeHOSetting(int.tryParse(s.value), s, ho);
          if (s.type == 'bool' && s.value is String) onChangeHOSetting(bool.tryParse(s.value), s, ho);
        }
      });
      ho.setting.sort((a, b) => b.type.compareTo(a.type));
      for (var ao in ho.airlineOverride) {
        ao.setting.forEach((s) {
          if (s.value == null && s.type == 'bool') {
            changeAOSetting(false, s, ao, ho);
          } else {
            if (s.type == 'int') changeAOSetting(int.tryParse(s.value), s, ao, ho);
            if (s.type == 'bool' && s.value is String) changeAOSetting(bool.tryParse(s.value), s, ao, ho);
          }
        });
        ao.setting.sort((a, b) => b.type.compareTo(a.type));
      }
    });
    updatingData.update((state) => airportSetting);
  }

  @override
  void onInit() {
    initialize();
    super.onInit();
  }
}
