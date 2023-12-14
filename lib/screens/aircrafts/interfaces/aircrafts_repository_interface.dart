import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/add_aircraft_usecase.dart';
import '../usecases/delete_aircraft.dart';
import '../usecases/get_aircraft_list.dart';

abstract class AircraftsRepositoryInterface {
  Future<Either<Failure, GetAircraftListResponse>> getAircraftList(GetAircraftListRequest request);
  Future<Either<Failure, AddAirCraftResponse>> addAirCraft(AddAirCraftRequest request);
  Future<Either<Failure, DeleteAircraftResponse>> deleteAircraft(DeleteAircraftRequest request);
}
