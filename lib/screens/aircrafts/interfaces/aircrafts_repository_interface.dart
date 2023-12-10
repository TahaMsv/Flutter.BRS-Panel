import 'package:brs_panel/screens/aircrafts/usecases/add_aircraft_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';

abstract class AircraftsRepositoryInterface {
  // Future<Either<Failure, AircraftsResponse>> aircrafts(AircraftsRequest request);
  Future<Either<Failure, AddAirCraftResponse>> addAirCraft(AddAirCraftRequest request);

}