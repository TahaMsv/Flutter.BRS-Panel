import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../../../core/util/parser.dart';
import '../interfaces/flight_summary_data_source_interface.dart';
import '../usecases/flight_get_history_log_usecase.dart';
import '../usecases/flight_get_summary_usecase.dart';
import 'flight_summary_local_ds.dart';

class FlightSummaryRemoteDataSource implements FlightSummaryDataSourceInterface {
  final FlightSummaryLocalDataSource localDataSource = FlightSummaryLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  FlightSummaryRemoteDataSource();

  @override
  Future<FlightGetSummaryResponse> flightGetSummary({required FlightGetSummaryRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightGetSummaryResponse.fromResponse(res);
  }

  @override
  Future<FlightGetHistoryLogResponse> flightGetHistoryLog({required FlightGetHistoryLogRequest request}) async {
    Response res = await networkManager.post(request);
    FlightGetHistoryLogResponse response = await Parser().pars(FlightGetHistoryLogResponse.fromResponse, res);
    return response;
  }
}
