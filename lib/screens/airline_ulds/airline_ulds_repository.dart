import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airline_ulds_repository_interface.dart';
import 'data_sources/airline_ulds_local_ds.dart';
import 'data_sources/airline_ulds_remote_ds.dart';
import 'usecases/airline_get_ulds_usecase.dart';

class AirlineUldsRepository implements AirlineUldsRepositoryInterface {
  final AirlineUldsRemoteDataSource airlineUldsRemoteDataSource = AirlineUldsRemoteDataSource();
  final AirlineUldsLocalDataSource airlineUldsLocalDataSource = AirlineUldsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirlineUldsRepository();

  @override
  Future<Either<Failure, AirlineGetUldListResponse>> airlineGetUldList(AirlineGetUldListRequest request) async {
    try {
      AirlineGetUldListResponse airlineGetUldListResponse;
      if (await networkInfo.isConnected) {
        airlineGetUldListResponse = await airlineUldsRemoteDataSource.airlineGetUldList(request: request);
      } else {
        airlineGetUldListResponse = await airlineUldsLocalDataSource.airlineGetUldList(request: request);
      }
      return Right(airlineGetUldListResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
