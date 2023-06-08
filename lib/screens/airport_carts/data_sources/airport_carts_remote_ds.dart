import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/airport_carts_data_source_interface.dart';
import '../usecase/airline_add_uld_usecase.dart';
import '../usecase/airline_delete_uld_usecase.dart';
import '../usecase/airline_update_uld_usecase.dart';
import '../usecase/airport_get_carts_usecase.dart';
import 'airport_carts_local_ds.dart';

class AirportCartsRemoteDataSource implements AirportCartsDataSourceInterface {
  final AirportCartsLocalDataSource localDataSource = AirportCartsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  AirportCartsRemoteDataSource();

  @override
  Future<AirportGetCartsResponse> airportGetCarts({required AirportGetCartsRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportGetCartsResponse.fromResponse(res);
  }

  @override
  Future<AirportAddCartResponse> airportAddCart({required AirportAddCartRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportAddCartResponse.fromResponse(res);
  }

  @override
  Future<AirportUpdateCartResponse> airportUpdateCart({required AirportUpdateCartRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportUpdateCartResponse.fromResponse(res);
  }

  @override
  Future<AirportDeleteCartResponse> airportDeleteCart({required AirportDeleteCartRequest request}) async {
    Response res = await networkManager.post(request);
    return AirportDeleteCartResponse.fromResponse(res);
  }
}
