import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/flights_data_source_interface.dart';
import '../usecases/flight_add_remove_container_usecase.dart';
import '../usecases/flight_get_container_list_usecase.dart';
import '../usecases/flight_get_containers_plan_usecase.dart';
import '../usecases/flight_get_plan_file.dart';
import '../usecases/flight_list_usecase.dart';
import '../usecases/flight_save_containers_plan_usecase.dart';
import 'flights_local_ds.dart';

class FlightsRemoteDataSource implements FlightsDataSourceInterface {
  final FlightsLocalDataSource localDataSource = FlightsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  FlightsRemoteDataSource();

  @override
  Future<FlightListResponse> flightList({required FlightListRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightListResponse.fromResponse(res);
  }

  @override
  Future<FlightGetContainerListResponse> flightGetContainerList({required FlightGetContainerListRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightGetContainerListResponse.fromResponse(res);
  }

  @override
  Future<FlightAddRemoveContainerResponse> flightAddRemoveContainer({required FlightAddRemoveContainerRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightAddRemoveContainerResponse.fromResponse(res);
  }

  @override
  Future<FlightGetContainersPlanResponse> flightGetContainersPlan({required FlightGetContainersPlanRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightGetContainersPlanResponse.fromResponse(res);
  }

  @override
  Future<FlightGetPlanFileResponse> flightGetPlanFile({required FlightGetPlanFileRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightGetPlanFileResponse.fromResponse(res);
  }

    @override
      Future<FlightSaveContainersPlanResponse> flightSaveContainersPlan({required FlightSaveContainersPlanRequest request}) async {
        Response res = await networkManager.post(request);
        FlightSaveContainersPlanResponse response =  FlightSaveContainersPlanResponse.fromResponse(res);
        return response;
      }

}
