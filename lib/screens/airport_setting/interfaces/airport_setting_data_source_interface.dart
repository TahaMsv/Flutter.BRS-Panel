import '../usecase/airport_get_setting_usecase.dart';
import '../usecase/airport_update_setting_usecase.dart';

abstract class AirportSettingDataSourceInterface {
  Future<AirportGetSettingResponse> airportGetSetting({required AirportGetSettingRequest request});
  Future<AirportUpdateSettingResponse> airportUpdateSetting({required AirportUpdateSettingRequest request});
}
