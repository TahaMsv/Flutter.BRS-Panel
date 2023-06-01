import '../usecases/add_flight_usecase.dart';

abstract class AddFlightDataSourceInterface {
  Future<AddFlightResponse> addFlight({required AddFlightRequest request});
}