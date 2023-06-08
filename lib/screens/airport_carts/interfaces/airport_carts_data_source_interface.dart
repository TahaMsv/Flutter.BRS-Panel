import '../usecase/airline_add_uld_usecase.dart';
import '../usecase/airline_delete_uld_usecase.dart';
import '../usecase/airline_update_uld_usecase.dart';
import '../usecase/airport_get_carts_usecase.dart';

abstract class AirportCartsDataSourceInterface {
  Future<AirportGetCartsResponse> airportGetCarts({required AirportGetCartsRequest request});
  Future<AirportAddCartResponse> airportAddCart({required AirportAddCartRequest request});
  Future<AirportUpdateCartResponse> airportUpdateCart({required AirportUpdateCartRequest request});
  Future<AirportDeleteCartResponse> airportDeleteCart({required AirportDeleteCartRequest request});
}