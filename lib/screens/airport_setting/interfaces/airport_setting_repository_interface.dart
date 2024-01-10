import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecase/airport_get_setting_usecase.dart';
import '../usecase/airport_update_setting_usecase.dart';

abstract class AirportSettingRepositoryInterface {
  Future<Either<Failure, AirportGetSettingResponse>> airportGetSetting(AirportGetSettingRequest request);
  Future<Either<Failure, AirportUpdateSettingResponse>> airportUpdateSetting(AirportUpdateSettingRequest request);
}
