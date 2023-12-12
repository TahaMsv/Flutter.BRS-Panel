import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/airports_repository_interface.dart';
import 'data_sources/airports_local_ds.dart';
import 'data_sources/airports_remote_ds.dart';
import 'usecases/add_update_airport.dart';
import 'usecases/delete_airport.dart';
import 'usecases/get_airport_list.dart';

class AirportsRepository implements AirportsRepositoryInterface {
  final AirportsRemoteDataSource airportsRemoteDataSource = AirportsRemoteDataSource();
  final AirportsLocalDataSource airportsLocalDataSource = AirportsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AirportsRepository();

  @override
  Future<Either<Failure, GetAirportListResponse>> getAirportList(GetAirportListRequest request) async {
    try {
      GetAirportListResponse getAirportListResponse;
      if (await networkInfo.isConnected) {
        getAirportListResponse = await airportsRemoteDataSource.getAirportList(request: request);
      } else {
        getAirportListResponse = await airportsLocalDataSource.getAirportList(request: request);
      }
      return Right(getAirportListResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, AddUpdateAirportResponse>> addUpdateAirport(AddUpdateAirportRequest request) async {
    try {
      AddUpdateAirportResponse addUpdateAirportResponse;
      if (await networkInfo.isConnected) {
        addUpdateAirportResponse = await airportsRemoteDataSource.addUpdateAirport(request: request);
      } else {
        addUpdateAirportResponse = await airportsLocalDataSource.addUpdateAirport(request: request);
      }
      return Right(addUpdateAirportResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, DeleteAirportResponse>> deleteAirport(DeleteAirportRequest request) async {
    try {
      DeleteAirportResponse deleteAirportResponse;
      if (await networkInfo.isConnected) {
        deleteAirportResponse = await airportsRemoteDataSource.deleteAirport(request: request);
      } else {
        deleteAirportResponse = await airportsLocalDataSource.deleteAirport(request: request);
      }
      return Right(deleteAirportResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
