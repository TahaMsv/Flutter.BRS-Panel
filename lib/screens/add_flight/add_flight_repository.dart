import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/add_flight_repository_interface.dart';
import 'data_sources/add_flight_local_ds.dart';
import 'data_sources/add_flight_remote_ds.dart';
import 'usecases/add_flight_usecase.dart';

class AddFlightRepository implements AddFlightRepositoryInterface {
  final AddFlightRemoteDataSource addFlightRemoteDataSource = AddFlightRemoteDataSource();
  final AddFlightLocalDataSource addFlightLocalDataSource = AddFlightLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  AddFlightRepository();

  @override
  Future<Either<Failure, AddFlightResponse>> addFlight(AddFlightRequest request) async {
    try {
      AddFlightResponse addFlightResponse;
      if (await networkInfo.isConnected) {
        addFlightResponse = await addFlightRemoteDataSource.addFlight(request: request);
        //update local
      } else {
        addFlightResponse = await addFlightLocalDataSource.addFlight(request: request);
      }
      return Right(addFlightResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
