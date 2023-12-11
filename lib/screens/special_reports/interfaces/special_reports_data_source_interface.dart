import '../usecases/get_sr_list_usecase.dart';

abstract class SpecialReportsDataSourceInterface {
  Future<GetSpecialReportListResponse> getSpecialReportsList({required GetSpecialReportListRequest request});
}
