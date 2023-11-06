import 'package:brs_panel/screens/flight_summary/usecases/flight_get_summary_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/flight_get_history_log_usecase.dart';

abstract class FlightSummaryRepositoryInterface {
  Future<Either<Failure, FlightGetSummaryResponse>> flightGetSummary(FlightGetSummaryRequest request);
  Future<Either<Failure, FlightGetHistoryLogResponse>> flightGetHistoryLog(FlightGetHistoryLogRequest request);
}