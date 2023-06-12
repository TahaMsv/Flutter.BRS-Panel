import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/flights_repository_interface.dart';
import 'data_sources/flights_local_ds.dart';
import 'data_sources/flights_remote_ds.dart';
import 'usecases/flight_add_remove_container_usecase.dart';
import 'usecases/flight_get_container_list_usecase.dart';
import 'usecases/flight_list_usecase.dart';

class FlightsRepository implements FlightsRepositoryInterface {
  final FlightsRemoteDataSource flightsRemoteDataSource = FlightsRemoteDataSource();
  final FlightsLocalDataSource flightsLocalDataSource = FlightsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  FlightsRepository();

  @override
  Future<Either<Failure, FlightListResponse>> flightList(FlightListRequest request) async {
    try {
      FlightListResponse flightListResponse;
      if (await networkInfo.isConnected) {
        flightListResponse = await flightsRemoteDataSource.flightList(request: request);
      } else {
        flightListResponse = await flightsLocalDataSource.flightList(request: request);
      }
      return Right(flightListResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, FlightGetContainerListResponse>> flightGetContainerList(FlightGetContainerListRequest request) async {
    try {
      FlightGetContainerListResponse flightGetContainerListResponse;
      if (await networkInfo.isConnected) {
        flightGetContainerListResponse = await flightsRemoteDataSource.flightGetContainerList(request: request);
      } else {
        flightGetContainerListResponse = await flightsLocalDataSource.flightGetContainerList(request: request);
      }
      return Right(flightGetContainerListResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  Future<Either<Failure, FlightAddRemoveContainerResponse>> flightAddRemoveContainer(FlightAddRemoveContainerRequest request) async {
    try {
      FlightAddRemoveContainerResponse flightAddRemoveContainerResponse;
      if (await networkInfo.isConnected) {
        flightAddRemoveContainerResponse = await flightsRemoteDataSource.flightAddRemoveContainer(request: request);
      } else {
        flightAddRemoveContainerResponse = await flightsLocalDataSource.flightAddRemoveContainer(request: request);
      }
      return Right(flightAddRemoveContainerResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

}
