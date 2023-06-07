import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/airline_get_ulds_usecase.dart';

abstract class AirlineUldsRepositoryInterface {
  Future<Either<Failure, AirlineGetUldListResponse>> airlineGetUldList(AirlineGetUldListRequest request);
}