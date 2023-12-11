import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/special_reports_repository_interface.dart';
import 'data_sources/special_reports_local_ds.dart';
import 'data_sources/special_reports_remote_ds.dart';
import 'usecases/get_sr_list_usecase.dart';

class SpecialReportsRepository implements SpecialReportsRepositoryInterface {
  final SpecialReportsRemoteDataSource specialReportsRemoteDataSource = SpecialReportsRemoteDataSource();
  final SpecialReportsLocalDataSource specialReportsLocalDataSource = SpecialReportsLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  SpecialReportsRepository();

  @override
  Future<Either<Failure, GetSpecialReportListResponse>> getSpecialReportsList(
      GetSpecialReportListRequest request) async {
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
}
