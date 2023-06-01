import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/flights_repository_interface.dart';
import 'data_sources/flights_local_ds.dart';
import 'data_sources/flights_remote_ds.dart';
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
}
