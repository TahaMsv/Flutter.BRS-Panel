import '../usecases/add_aircraft_usecase.dart';
import '../usecases/delete_aircraft.dart';
import '../usecases/get_aircraft_list.dart';

abstract class AircraftsDataSourceInterface {
  Future<GetAircraftListResponse> getAircraftList({required GetAircraftListRequest request});
  Future<AddAirCraftResponse> addAirCraft({required AddAirCraftRequest request});
  Future<DeleteAircraftResponse> deleteAircraft({required DeleteAircraftRequest request});
}