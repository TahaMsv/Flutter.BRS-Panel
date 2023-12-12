import '../usecases/add_aircraft_usecase.dart';
import '../usecases/delete_aircraft.dart';

abstract class AircraftsDataSourceInterface {
  Future<AddAirCraftResponse> addAirCraft({required AddAirCraftRequest request});
  Future<DeleteAircraftResponse> deleteAircraft({required DeleteAircraftRequest request});
}