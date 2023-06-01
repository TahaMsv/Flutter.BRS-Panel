import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/flights_data_source_interface.dart';
import '../usecases/flight_list_usecase.dart';
import 'flights_local_ds.dart';

class FlightsRemoteDataSource implements FlightsDataSourceInterface {
  final FlightsLocalDataSource localDataSource = FlightsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  FlightsRemoteDataSource();

  @override
  Future<FlightListResponse> flightList({required FlightListRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightListResponse.fromResponse(res);
  }
}
