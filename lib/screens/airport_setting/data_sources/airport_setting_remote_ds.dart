import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airport_setting_data_source_interface.dart';
import '../usecase/airport_get_setting_usecase.dart';
import '../usecase/airport_update_setting_usecase.dart';
import 'airport_setting_local_ds.dart';

class AirportSettingRemoteDataSource implements AirportSettingDataSourceInterface {
  final AirportSettingLocalDataSource localDataSource = AirportSettingLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AirportSettingRemoteDataSource();

  @override
  Future<AirportGetSettingResponse> airportGetSetting({required AirportGetSettingRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportGetSettingResponse.fromResponse(res);
  }

  @override
  Future<AirportUpdateSettingResponse> airportUpdateSetting({required AirportUpdateSettingRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportUpdateSettingResponse.fromResponse(res);
  }
}
