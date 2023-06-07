import '../usecases/flight_get_details_usecase.dart';

abstract class FlightDetailsDataSourceInterface {
  Future<FlightGetDetailsResponse> flightGetDetails({required FlightGetDetailsRequest request});
}