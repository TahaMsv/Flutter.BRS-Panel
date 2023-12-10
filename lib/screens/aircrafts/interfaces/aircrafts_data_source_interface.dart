import 'package:brs_panel/screens/aircrafts/usecases/add_aircraft_usecase.dart';

abstract class AircraftsDataSourceInterface {
  // Future<Response> ({required Request request});
  Future<AddAirCraftResponse> addAirCraft({required AddAirCraftRequest request});

}