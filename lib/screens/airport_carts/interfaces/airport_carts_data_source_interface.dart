import '../usecase/airport_get_carts_usecase.dart';

abstract class AirportCartsDataSourceInterface {
  Future<AirportGetCartsResponse> airportGetCarts({required AirportGetCartsRequest request});
}