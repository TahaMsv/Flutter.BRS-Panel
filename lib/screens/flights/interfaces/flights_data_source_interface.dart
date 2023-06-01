import '../usecases/flight_list_usecase.dart';

abstract class FlightsDataSourceInterface {
  Future<FlightListResponse> flightList({required FlightListRequest request});
}