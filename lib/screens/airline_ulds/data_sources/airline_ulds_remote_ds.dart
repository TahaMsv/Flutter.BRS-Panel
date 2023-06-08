import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airline_ulds_data_source_interface.dart';
import '../usecases/airline_add_uld_usecase.dart';
import '../usecases/airline_delete_uld_usecase.dart';
import '../usecases/airline_get_ulds_usecase.dart';
import '../usecases/airline_update_uld_usecase.dart';
import 'airline_ulds_local_ds.dart';

class AirlineUldsRemoteDataSource implements AirlineUldsDataSourceInterface {
  final AirlineUldsLocalDataSource localDataSource = AirlineUldsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AirlineUldsRemoteDataSource();

  @override
  Future<AirlineGetUldListResponse> airlineGetUldList({required AirlineGetUldListRequest request}) async {
    Response res = await networkManager.post(request);
    return AirlineGetUldListResponse.fromResponse(res);
  }

  @override
  Future<AirlineAddUldResponse> airlineAddUld({required AirlineAddUldRequest request}) async {
    Response res = await networkManager.post(request);
    return AirlineAddUldResponse.fromResponse(res);
  }

  @override
  Future<AirlineUpdateUldResponse> airlineUpdateUld({required AirlineUpdateUldRequest request}) async {
    Response res = await networkManager.post(request);
    return AirlineUpdateUldResponse.fromResponse(res);
  }

    @override
      Future<AirlineDeleteUldResponse> airlineDeleteUld({required AirlineDeleteUldRequest request}) async {
        Response res = await networkManager.post(request);
        return AirlineDeleteUldResponse.fromResponse(res);
      }

}
