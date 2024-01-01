import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airport_setting_repository_interface.dart';
import 'data_sources/airport_setting_local_ds.dart';
import 'data_sources/airport_setting_remote_ds.dart';
import 'usecase/airport_get_setting_usecase.dart';

class AirportSettingRepository implements AirportSettingRepositoryInterface {
  final AirportSettingRemoteDataSource airportSettingRemoteDataSource = AirportSettingRemoteDataSource();
  final AirportSettingLocalDataSource airportSettingLocalDataSource = AirportSettingLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirportSettingRepository();

  @override
  Future<Either<Failure, AirportGetSettingResponse>> airportGetSetting(AirportGetSettingRequest request) async {
    try {
      AirportGetSettingResponse settingResponse;
      if (await networkInfo.isConnected) {
        settingResponse = await airportSettingRemoteDataSource.airportGetSetting(request: request);
      } else {
        settingResponse = await airportSettingLocalDataSource.airportGetSetting(request: request);
      }
      return Right(settingResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
