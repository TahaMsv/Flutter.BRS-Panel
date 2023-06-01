import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/add_flight_usecase.dart';

abstract class AddFlightRepositoryInterface {
  Future<Either<Failure, AddFlightResponse>> addFlight(AddFlightRequest request);
}