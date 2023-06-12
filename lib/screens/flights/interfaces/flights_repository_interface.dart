import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/flight_add_remove_container_usecase.dart';
import '../usecases/flight_get_container_list_usecase.dart';

abstract class FlightsRepositoryInterface {
  Future<Either<Failure, FlightListResponse>> flightList(FlightListRequest request);
  Future<Either<Failure, FlightGetContainerListResponse>> flightGetContainerList(FlightGetContainerListRequest request);
  Future<Either<Failure, FlightAddRemoveContainerResponse>> flightAddRemoveContainer(FlightAddRemoveContainerRequest request);
}