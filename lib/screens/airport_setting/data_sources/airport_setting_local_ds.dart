import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/airport_setting_data_source_interface.dart';
import '../usecase/airport_get_setting_usecase.dart';
import '../usecase/airport_update_setting_usecase.dart';

const String userJsonLocalKey = "UserJson";

class AirportSettingLocalDataSource implements AirportSettingDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  AirportSettingLocalDataSource();

  @override
  Future<AirportGetSettingResponse> airportGetSetting({required AirportGetSettingRequest request}) {
    // TODO: implement airportGetSetting
    throw UnimplementedError();
  }

  @override
  Future<AirportUpdateSettingResponse> airportUpdateSetting({required AirportUpdateSettingRequest request}) {
    // TODO: implement airportUpdateSetting
    throw UnimplementedError();
  }
}
