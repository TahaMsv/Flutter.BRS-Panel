import '../usecases/airline_get_ulds_usecase.dart';

abstract class AirlineUldsDataSourceInterface {
  Future<AirlineGetUldListResponse> airlineGetUldList({required AirlineGetUldListRequest request});
}