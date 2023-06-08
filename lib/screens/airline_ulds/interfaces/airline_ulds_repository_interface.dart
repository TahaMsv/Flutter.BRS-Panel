import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/airline_add_uld_usecase.dart';
import '../usecases/airline_delete_uld_usecase.dart';
import '../usecases/airline_get_ulds_usecase.dart';
import '../usecases/airline_update_uld_usecase.dart';

abstract class AirlineUldsRepositoryInterface {
  Future<Either<Failure, AirlineGetUldListResponse>> airlineGetUldList(AirlineGetUldListRequest request);
  Future<Either<Failure, AirlineAddUldResponse>> airlineAddUld(AirlineAddUldRequest request);
  Future<Either<Failure, AirlineUpdateUldResponse>> airlineUpdateUld(AirlineUpdateUldRequest request);
  Future<Either<Failure, AirlineDeleteUldResponse>> airlineDeleteUld(AirlineDeleteUldRequest request);
}