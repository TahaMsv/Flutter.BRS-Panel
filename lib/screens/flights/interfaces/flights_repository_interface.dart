import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';

abstract class FlightsRepositoryInterface {
  Future<Either<Failure, FlightListResponse>> flightList(FlightListRequest request);
}