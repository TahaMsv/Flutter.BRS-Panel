import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../usecases/get_sr_list_usecase.dart';

abstract class SpecialReportsRepositoryInterface {
  Future<Either<Failure, GetSpecialReportListResponse>> getSpecialReportsList(GetSpecialReportListRequest request);
}
