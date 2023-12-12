import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/aircrafts_data_source_interface.dart';
import '../usecases/add_aircraft_usecase.dart';
import '../usecases/delete_aircraft.dart';
import 'aircrafts_local_ds.dart';

class AircraftsRemoteDataSource implements AircraftsDataSourceInterface {
  final AircraftsLocalDataSource localDataSource = AircraftsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AircraftsRemoteDataSource();

  @override
  Future<AddAirCraftResponse> addAirCraft({required AddAirCraftRequest request}) async {
    Response res = await networkManager.post(request);
    return AddAirCraftResponse.fromResponse(res);
  }

  @override
  Future<DeleteAircraftResponse> deleteAircraft({required DeleteAircraftRequest request}) async {
    Response res = await networkManager.post(request);
    return DeleteAircraftResponse.fromResponse(res);
  }
}
