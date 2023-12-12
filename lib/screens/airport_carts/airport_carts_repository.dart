import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airport_carts_repository_interface.dart';
import 'data_sources/airport_carts_local_ds.dart';
import 'data_sources/airport_carts_remote_ds.dart';
import 'usecase/airline_add_uld_usecase.dart';
import 'usecase/airline_delete_uld_usecase.dart';
import 'usecase/airline_update_uld_usecase.dart';
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

  @override
  Future<Either<Failure, AirportAddCartResponse>> airportAddCart(AirportAddCartRequest request) async {
    try {
      AirportAddCartResponse airportAddCartResponse;
      if (await networkInfo.isConnected) {
        airportAddCartResponse = await airportCartsRemoteDataSource.airportAddCart(request: request);
      } else {
        airportAddCartResponse = await airportCartsLocalDataSource.airportAddCart(request: request);
      }
      return Right(airportAddCartResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, AirportUpdateCartResponse>> airportUpdateCart(AirportUpdateCartRequest request) async {
    try {
      AirportUpdateCartResponse airportUpdateCartResponse;
      if (await networkInfo.isConnected) {
        airportUpdateCartResponse = await airportCartsRemoteDataSource.airportUpdateCart(request: request);
      } else {
        airportUpdateCartResponse = await airportCartsLocalDataSource.airportUpdateCart(request: request);
      }
      return Right(airportUpdateCartResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, AirportDeleteCartResponse>> airportDeleteCart(AirportDeleteCartRequest request) async {
    try {
      AirportDeleteCartResponse airportDeleteCartResponse;
      if (await networkInfo.isConnected) {
        airportDeleteCartResponse = await airportCartsRemoteDataSource.airportDeleteCart(request: request);
      } else {
        airportDeleteCartResponse = await airportCartsLocalDataSource.airportDeleteCart(request: request);
      }
      return Right(airportDeleteCartResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
