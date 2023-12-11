import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/get_params_options_usecase.dart';
import '../usecases/get_special_report_result_usecase.dart';
import '../usecases/get_sr_list_usecase.dart';

abstract class SpecialReportsRepositoryInterface {
  Future<Either<Failure, GetSpecialReportListResponse>> getSpecialReportsList(GetSpecialReportListRequest request);
  Future<Either<Failure, GetParamsOptionsResponse>> getParamsOptions(GetParamsOptionsRequest request);
  Future<Either<Failure, GetSpecialReportResultResponse>> getSpecialReportResult(GetSpecialReportResultRequest request);
}
