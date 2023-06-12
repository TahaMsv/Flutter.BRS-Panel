import '../usecases/flight_add_remove_container_usecase.dart';
import '../usecases/flight_get_container_list_usecase.dart';
import '../usecases/flight_list_usecase.dart';

abstract class FlightsDataSourceInterface {
  Future<FlightListResponse> flightList({required FlightListRequest request});
  Future<FlightGetContainerListResponse> flightGetContainerList({required FlightGetContainerListRequest request});
  Future<FlightAddRemoveContainerResponse> flightAddRemoveContainer({required FlightAddRemoveContainerRequest request});
}