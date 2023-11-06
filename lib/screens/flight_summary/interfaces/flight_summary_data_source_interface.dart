import '../usecases/flight_get_history_log_usecase.dart';
import '../usecases/flight_get_summary_usecase.dart';

abstract class FlightSummaryDataSourceInterface {
  Future<FlightGetSummaryResponse> flightGetSummary({required FlightGetSummaryRequest request});
  Future<FlightGetHistoryLogResponse> flightGetHistoryLog({required FlightGetHistoryLogRequest request});
}