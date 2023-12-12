import '../usecases/add_update_airport.dart';
import '../usecases/delete_airport.dart';
import '../usecases/get_airport_list.dart';

abstract class AirportsDataSourceInterface {
  Future<GetAirportListResponse> getAirportList({required GetAirportListRequest request});
  Future<AddUpdateAirportResponse> addUpdateAirport({required AddUpdateAirportRequest request});
  Future<DeleteAirportResponse> deleteAirport({required DeleteAirportRequest request});
}
