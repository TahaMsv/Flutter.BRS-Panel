import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airport_carts_repository_interface.dart';
import 'data_sources/airport_carts_local_ds.dart';
import 'data_sources/airport_carts_remote_ds.dart';
import 'usecase/airport_get_carts_usecase.dart';

class AirportCartsRepository implements AirportCartsRepositoryInterface {
  final AirportCartsRemoteDataSource airportCartsRemoteDataSource = AirportCartsRemoteDataSource();
  final AirportCartsLocalDataSource airportCartsLocalDataSource = AirportCartsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirportCartsRepository();

  @override
  Future<Either<Failure, AirportGetCartsResponse>> airportGetCarts(AirportGetCartsRequest request) async {
    try {
      AirportGetCartsResponse airportGetCartsResponse;
      if (await networkInfo.isConnected) {
        airportGetCartsResponse = await airportCartsRemoteDataSource.airportGetCarts(request: request);
      } else {
        airportGetCartsResponse = await airportCartsLocalDataSource.airportGetCarts(request: request);
      }
      return Right(airportGetCartsResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
