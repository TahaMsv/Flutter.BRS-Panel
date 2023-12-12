import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/add_aircraft_usecase.dart';
import '../usecases/delete_aircraft.dart';

abstract class AircraftsRepositoryInterface {
  // Future<Either<Failure, AircraftsResponse>> aircrafts(AircraftsRequest request);
  Future<Either<Failure, AddAirCraftResponse>> addAirCraft(AddAirCraftRequest request);
  Future<Either<Failure, DeleteAircraftResponse>> deleteAircraft(DeleteAircraftRequest request);
}
