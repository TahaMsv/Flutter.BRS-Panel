import '../../core/abstracts/controller_abs.dart';
import '../../core/util/handlers/failure_handler.dart';
import 'special_reports_state.dart';
import 'usecases/get_sr_list_usecase.dart';

class SpecialReportsController extends MainController {
  late SpecialReportsState specialReportsState = ref.read(specialReportsProvider);

  /// View -------------------------------------------------------------------------------------------------------------

  /// Requests ---------------------------------------------------------------------------------------------------------

  getSpecialReportList() async {
    GetSpecialReportListRequest request = GetSpecialReportListRequest(reportType: null);
    GetSpecialReportListUseCase useCase = GetSpecialReportListUseCase();
    final fOrR = await useCase(request: request);
    fOrR.fold((l) => FailureHandler.handle(l, retry: getSpecialReportList), (r) {});
  }

  /// Core ---------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    getSpecialReportList();
    super.onInit();
  }
}
