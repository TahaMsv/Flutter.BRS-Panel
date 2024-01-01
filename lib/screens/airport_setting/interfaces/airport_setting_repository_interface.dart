import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecase/airport_get_setting_usecase.dart';

abstract class AirportSettingRepositoryInterface {
  Future<Either<Failure, AirportGetSettingResponse>> airportGetSetting(AirportGetSettingRequest request);
}
