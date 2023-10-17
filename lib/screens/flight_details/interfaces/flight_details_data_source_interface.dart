import '../usecases/flight_get_details_usecase.dart';
import '../usecases/flight_get_tag_details_usecase.dart';

abstract class FlightDetailsDataSourceInterface {
  Future<FlightGetDetailsResponse> flightGetDetails({required FlightGetDetailsRequest request});
  Future<FlightGetTagMoreDetailsResponse> flightGetTagMoreDetails({required FlightGetTagMoreDetailsRequest request});
}