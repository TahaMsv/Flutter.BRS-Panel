import '../usecases/airline_add_uld_usecase.dart';
import '../usecases/airline_delete_uld_usecase.dart';
import '../usecases/airline_get_ulds_usecase.dart';
import '../usecases/airline_update_uld_usecase.dart';

abstract class AirlineUldsDataSourceInterface {
  Future<AirlineGetUldListResponse> airlineGetUldList({required AirlineGetUldListRequest request});
  Future<AirlineAddUldResponse> airlineAddUld({required AirlineAddUldRequest request});
  Future<AirlineUpdateUldResponse> airlineUpdateUld({required AirlineUpdateUldRequest request});
  Future<AirlineDeleteUldResponse> airlineDeleteUld({required AirlineDeleteUldRequest request});
}