import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/add_update_airport.dart';
import '../usecases/delete_airport.dart';
import '../usecases/get_airport_list.dart';

abstract class AirportsRepositoryInterface {
  Future<Either<Failure, GetAirportListResponse>> getAirportList(GetAirportListRequest request);
  Future<Either<Failure, AddUpdateAirportResponse>> addUpdateAirport(AddUpdateAirportRequest request);
  Future<Either<Failure, DeleteAirportResponse>> deleteAirport(DeleteAirportRequest request);
}
