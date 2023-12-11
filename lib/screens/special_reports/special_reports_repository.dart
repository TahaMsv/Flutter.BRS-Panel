import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/special_reports_repository_interface.dart';
import 'data_sources/special_reports_local_ds.dart';
import 'data_sources/special_reports_remote_ds.dart';
import 'usecases/get_params_options_usecase.dart';
import 'usecases/get_special_report_result_usecase.dart';
import 'usecases/get_sr_list_usecase.dart';

class SpecialReportsRepository implements SpecialReportsRepositoryInterface {
  final SpecialReportsRemoteDataSource specialReportsRemoteDataSource = SpecialReportsRemoteDataSource();
  final SpecialReportsLocalDataSource specialReportsLocalDataSource = SpecialReportsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  SpecialReportsRepository();

  @override
  Future<Either<Failure, GetSpecialReportListResponse>> getSpecialReportsList(GetSpecialReportListRequest request) async {
    try {
      GetSpecialReportListResponse getSpecialReportListResponse;
      if (await networkInfo.isConnected) {
        getSpecialReportListResponse = await specialReportsRemoteDataSource.getSpecialReportsList(request: request);
      } else {
        getSpecialReportListResponse = await specialReportsLocalDataSource.getSpecialReportsList(request: request);
      }
      return Right(getSpecialReportListResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, GetParamsOptionsResponse>> getParamsOptions(GetParamsOptionsRequest request) async {
    try {
      GetParamsOptionsResponse getParamsOptionsResponse;
      if (await networkInfo.isConnected) {
        getParamsOptionsResponse = await specialReportsRemoteDataSource.getParamsOptions(request: request);
      } else {
        getParamsOptionsResponse = await specialReportsLocalDataSource.getParamsOptions(request: request);
      }
      return Right(getParamsOptionsResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }

  @override
  Future<Either<Failure, GetSpecialReportResultResponse>> getSpecialReportResult(GetSpecialReportResultRequest request) async {
    try {
      GetSpecialReportResultResponse getSpecialReportResultResponse;
      if (await networkInfo.isConnected) {
        getSpecialReportResultResponse = await specialReportsRemoteDataSource.getSpecialReportResult(request: request);
      } else {
        getSpecialReportResultResponse = await specialReportsLocalDataSource.getSpecialReportResult(request: request);
      }
      return Right(getSpecialReportResultResponse);
    } on AppException catch (e) {
      return Left(ServerFailure.fromAppException(e));
    }
  }
}
