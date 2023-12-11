import '../usecases/get_params_options_usecase.dart';
import '../usecases/get_special_report_result_usecase.dart';
import '../usecases/get_sr_list_usecase.dart';

abstract class SpecialReportsDataSourceInterface {
  Future<GetSpecialReportListResponse> getSpecialReportsList({required GetSpecialReportListRequest request});
  Future<GetParamsOptionsResponse> getParamsOptions({required GetParamsOptionsRequest request});
  Future<GetSpecialReportResultResponse> getSpecialReportResult({required GetSpecialReportResultRequest request});
}
