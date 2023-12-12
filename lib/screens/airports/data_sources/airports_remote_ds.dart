import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airports_data_source_interface.dart';
import '../usecases/add_update_airport.dart';
import '../usecases/delete_airport.dart';
import '../usecases/get_airport_list.dart';
import 'airports_local_ds.dart';

class AirportsRemoteDataSource implements AirportsDataSourceInterface {
  final AirportsLocalDataSource localDataSource = AirportsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AirportsRemoteDataSource();

  @override
  Future<GetAirportListResponse> getAirportList({required GetAirportListRequest request}) async {
    Response res = await networkManager.post(request);
    return GetAirportListResponse.fromResponse(res);
  }

  @override
  Future<AddUpdateAirportResponse> addUpdateAirport({required AddUpdateAirportRequest request}) async {
    Response res = await networkManager.post(request);
    return AddUpdateAirportResponse.fromResponse(res);
  }

  @override
  Future<DeleteAirportResponse> deleteAirport({required DeleteAirportRequest request}) async {
    Response res = await networkManager.post(request);
    return DeleteAirportResponse.fromResponse(res);
  }
}
