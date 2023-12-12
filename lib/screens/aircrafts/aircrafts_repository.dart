import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/aircrafts_repository_interface.dart';
import 'data_sources/aircrafts_local_ds.dart';
import 'data_sources/aircrafts_remote_ds.dart';
import 'usecases/add_aircraft_usecase.dart';
import 'usecases/delete_aircraft.dart';

class AircraftsRepository implements AircraftsRepositoryInterface {
  final AircraftsRemoteDataSource aircraftsRemoteDataSource = AircraftsRemoteDataSource();
  final AircraftsLocalDataSource aircraftsLocalDataSource = AircraftsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AircraftsRepository();

  @override
  Future<Either<Failure, AddAirCraftResponse>> addAirCraft(AddAirCraftRequest request) async {
    try {
      AddAirCraftResponse addAirCraftResponse;
      if (await networkInfo.isConnected) {
        addAirCraftResponse = await aircraftsRemoteDataSource.addAirCraft(request: request);
      } else {
        addAirCraftResponse = await aircraftsLocalDataSource.addAirCraft(request: request);
      }
      return Right(addAirCraftResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, DeleteAircraftResponse>> deleteAircraft(DeleteAircraftRequest request) async {
    try {
      DeleteAircraftResponse deleteAircraftResponse;
      if (await networkInfo.isConnected) {
        deleteAircraftResponse = await aircraftsRemoteDataSource.deleteAircraft(request: request);
      } else {
        deleteAircraftResponse = await aircraftsLocalDataSource.deleteAircraft(request: request);
      }
      return Right(deleteAircraftResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
