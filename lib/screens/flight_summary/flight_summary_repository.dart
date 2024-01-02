import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/flight_summary_repository_interface.dart';
import 'data_sources/flight_summary_local_ds.dart';
import 'data_sources/flight_summary_remote_ds.dart';
import 'usecases/flight_get_history_log_usecase.dart';
import 'usecases/flight_get_summary_usecase.dart';

class FlightSummaryRepository implements FlightSummaryRepositoryInterface {
  final FlightSummaryRemoteDataSource flightSummaryRemoteDataSource = FlightSummaryRemoteDataSource();
  final FlightSummaryLocalDataSource flightSummaryLocalDataSource = FlightSummaryLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  FlightSummaryRepository();

  @override
  Future<Either<Failure, FlightGetSummaryResponse>> flightGetSummary(FlightGetSummaryRequest request) async {
    try {
      FlightGetSummaryResponse flightGetSummaryResponse;
      if (await networkInfo.isConnected) {
        flightGetSummaryResponse = await flightSummaryRemoteDataSource.flightGetSummary(request: request);
      } else {
        flightGetSummaryResponse = await flightSummaryLocalDataSource.flightGetSummary(request: request);
      }
      return Right(flightGetSummaryResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, FlightGetHistoryLogResponse>> flightGetHistoryLog(FlightGetHistoryLogRequest request) async {
    try {
      FlightGetHistoryLogResponse flightGetHistoryLogResponse;
      if (await networkInfo.isConnected) {

        flightGetHistoryLogResponse = await flightSummaryRemoteDataSource.flightGetHistoryLog(request: request);
      } else {
        flightGetHistoryLogResponse = await flightSummaryLocalDataSource.flightGetHistoryLog(request: request);
      }
      return Right(flightGetHistoryLogResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
