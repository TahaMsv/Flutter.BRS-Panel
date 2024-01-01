import '../usecase/airport_get_setting_usecase.dart';

abstract class AirportSettingDataSourceInterface {
  Future<AirportGetSettingResponse> airportGetSetting({required AirportGetSettingRequest request});
}
