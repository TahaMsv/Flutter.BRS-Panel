import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/flight_details_repository_interface.dart';
import 'data_sources/flight_details_local_ds.dart';
import 'data_sources/flight_details_remote_ds.dart';
import 'usecases/delete_tag_usecase.dart';
import 'usecases/flight_get_details_usecase.dart';
import 'usecases/flight_get_tag_details_usecase.dart';
import 'usecases/get_container_pdf_usecase.dart';
import 'usecases/get_history_log_usecase.dart';

class FlightDetailsRepository implements FlightDetailsRepositoryInterface {
  final FlightDetailsRemoteDataSource flightDetailsRemoteDataSource = FlightDetailsRemoteDataSource();
  final FlightDetailsLocalDataSource flightDetailsLocalDataSource = FlightDetailsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  FlightDetailsRepository();

  @override
  Future<Either<Failure, FlightGetDetailsResponse>> flightGetDetails(FlightGetDetailsRequest request) async {
    try {
      FlightGetDetailsResponse flightGetDetailsResponse;
      if (await networkInfo.isConnected) {
        flightGetDetailsResponse = await flightDetailsRemoteDataSource.flightGetDetails(request: request);
      } else {
        flightGetDetailsResponse = await flightDetailsLocalDataSource.flightGetDetails(request: request);
      }
      return Right(flightGetDetailsResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, FlightGetTagMoreDetailsResponse>> flightGetTagMoreDetails(
      FlightGetTagMoreDetailsRequest request) async {
    try {
      FlightGetTagMoreDetailsResponse flightGetTagMoreDetailsResponse;
      if (await networkInfo.isConnected) {
        flightGetTagMoreDetailsResponse = await flightDetailsRemoteDataSource.flightGetTagMoreDetails(request: request);
      } else {
        flightGetTagMoreDetailsResponse = await flightDetailsLocalDataSource.flightGetTagMoreDetails(request: request);
      }
      return Right(flightGetTagMoreDetailsResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, GetContainerReportResponse>> getContainerReport(GetContainerReportRequest request) async {
    try {
      GetContainerReportResponse getContainerReportResponse;
      if (await networkInfo.isConnected) {
        getContainerReportResponse = await flightDetailsRemoteDataSource.getContainerReport(request: request);
      } else {
        getContainerReportResponse = await flightDetailsLocalDataSource.getContainerReport(request: request);
      }
      return Right(getContainerReportResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, DeleteTagResponse>> deleteTag(DeleteTagRequest request) async {
    try {
      DeleteTagResponse deleteTagResponse;
      if (await networkInfo.isConnected) {
        deleteTagResponse = await flightDetailsRemoteDataSource.deleteTag(request: request);
      } else {
        deleteTagResponse = await flightDetailsLocalDataSource.deleteTag(request: request);
      }
      return Right(deleteTagResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, GetHistoryLogResponse>> getHistoryLog(GetHistoryLogRequest request) async {
    try {
      GetHistoryLogResponse getHistoryLogResponse;
      if (await networkInfo.isConnected) {
        getHistoryLogResponse = await flightDetailsRemoteDataSource.getHistoryLog(request: request);
      } else {
        getHistoryLogResponse = await flightDetailsLocalDataSource.getHistoryLog(request: request);
      }
      return Right(getHistoryLogResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
