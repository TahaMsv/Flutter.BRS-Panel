import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/flight_add_remove_container_usecase.dart';
import '../usecases/flight_get_container_list_usecase.dart';
import '../usecases/flight_get_containers_plan_usecase.dart';
import '../usecases/flight_get_plan_file.dart';
import '../usecases/flight_get_report_usecase.dart';
import '../usecases/flight_save_containers_plan_usecase.dart';
import '../usecases/flight_send_report_usecase.dart';

abstract class FlightsRepositoryInterface {
  Future<Either<Failure, FlightListResponse>> flightList(FlightListRequest request);
  Future<Either<Failure, FlightGetContainerListResponse>> flightGetContainerList(FlightGetContainerListRequest request);
  Future<Either<Failure, FlightAddRemoveContainerResponse>> flightAddRemoveContainer(FlightAddRemoveContainerRequest request);
  Future<Either<Failure, FlightGetContainersPlanResponse>> flightGetContainersPlan(FlightGetContainersPlanRequest request);
  Future<Either<Failure, FlightGetPlanFileResponse>> flightGetPlanFile(FlightGetPlanFileRequest request);
  Future<Either<Failure, FlightSaveContainersPlanResponse>> flightSaveContainersPlan(FlightSaveContainersPlanRequest request);
  Future<Either<Failure, FlightGetReportResponse>> flightGetReport(FlightGetReportRequest request);
  Future<Either<Failure, FlightSendReportResponse>> flightSendReport(FlightSendReportRequest request);
}