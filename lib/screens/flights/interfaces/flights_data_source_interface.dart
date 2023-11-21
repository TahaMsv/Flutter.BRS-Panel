import '../usecases/flight_add_remove_container_usecase.dart';
import '../usecases/flight_get_container_list_usecase.dart';
import '../usecases/flight_get_containers_plan_usecase.dart';
import '../usecases/flight_get_plan_file.dart';
import '../usecases/flight_get_report_usecase.dart';
import '../usecases/flight_list_usecase.dart';
import '../usecases/flight_save_containers_plan_usecase.dart';
import '../usecases/flight_send_report_usecase.dart';

abstract class FlightsDataSourceInterface {
  Future<FlightListResponse> flightList({required FlightListRequest request});
  Future<FlightGetContainerListResponse> flightGetContainerList({required FlightGetContainerListRequest request});
  Future<FlightAddRemoveContainerResponse> flightAddRemoveContainer({required FlightAddRemoveContainerRequest request});
  Future<FlightGetContainersPlanResponse> flightGetContainersPlan({required FlightGetContainersPlanRequest request});
  Future<FlightGetPlanFileResponse> flightGetPlanFile({required FlightGetPlanFileRequest request});
  Future<FlightSaveContainersPlanResponse> flightSaveContainersPlan({required FlightSaveContainersPlanRequest request});
  Future<FlightGetReportResponse> flightGetReport({required FlightGetReportRequest request});
  Future<FlightSendReportResponse> flightSendReport({required FlightSendReportRequest request});
}