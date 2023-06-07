import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/flight_get_details_usecase.dart';

abstract class FlightDetailsRepositoryInterface {
  Future<Either<Failure, FlightGetDetailsResponse>> flightGetDetails(FlightGetDetailsRequest request);
}