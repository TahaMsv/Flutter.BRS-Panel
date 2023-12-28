import 'package:brs_panel/core/classes/special_report_class.dart';
import 'package:brs_panel/screens/special_reports/usecases/get_params_options_usecase.dart';
import 'package:brs_panel/screens/special_reports/usecases/get_special_report_result_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/special_report_data_class.dart';
import '../../core/classes/special_report_param_class.dart';
import '../../core/classes/special_report_param_option_class.dart';
import '../../core/classes/special_report_result_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../initialize.dart';
import 'special_reports_state.dart';
import 'usecases/get_sr_list_usecase.dart';

class SpecialReportsController extends MainController {
  late SpecialReportsState specialReportsState = ref.read(specialReportsProvider);

  /// View -------------------------------------------------------------------------------------------------------------

  onSelectReport(SpecialReport? v) {
    final SpecialReportData? spp = ref.watch(specialReportDataProvider);
    if (spp == null) return;
    ref.read(selectedSpecialReportProvider.notifier).update((state) => v);
    if (v != null && spp.parameters.where((e) => v.getParameters.contains(e.id)).any((element) => element.getType == SpecialReportParamTypes.dropDown)) {
      getParamsOption(v).then((value) {
        ref.read(specialReportOptionsProvider.notifier).update((state) => value);
      });
    }
    if (v == null) {
      ref.read(paramsDataProvider.notifier).update((state) => {});
    } else {
      Map<SpecialReportParam, ParamOption> newParams = {};
      for (var pId in v.getParameters) {
        SpecialReportParam p = spp.parameters.firstWhere((element) => element.id == pId);
        newParams.putIfAbsent(p, () => p.getType.initialValue);
      }
      ref.read(paramsDataProvider.notifier).update((state) => newParams);
    }
  }

  /// Requests ---------------------------------------------------------------------------------------------------------

  getSpecialReportList() async {
    GetSpecialReportListRequest request = GetSpecialReportListRequest(reportType: null);
    GetSpecialReportListUseCase useCase = GetSpecialReportListUseCase();
    ref.read(loadingSpecialReportDataProvider.notifier).update((state) => true);
    final fOrR = await useCase(request: request);
    ref.read(loadingSpecialReportDataProvider.notifier).update((state) => false);
    fOrR.fold((l) => FailureHandler.handle(l, retry: getSpecialReportList), (r) {
      final srp = ref.read(specialReportDataProvider.notifier);
      srp.update((state) => r.reportData);
    });
  }

  Future<List<SpecialReportParameterOptions>> getParamsOption(SpecialReport report) async {
    List<SpecialReportParameterOptions> options = [];
    GetParamsOptionsUseCase getParamsOptionUsecase = GetParamsOptionsUseCase();
    GetParamsOptionsRequest getParamsOptionsRequest = GetParamsOptionsRequest(report: report);
    ref.read(loadingParamsOptionsProvider.notifier).update((state) => true);
    final fOrR = await getParamsOptionUsecase(request: getParamsOptionsRequest);
    ref.read(loadingParamsOptionsProvider.notifier).update((state) => false);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => getParamsOption(report)), (r) {
      options = r.options;
    });
    return options;
  }

  Future<SpecialReportResult?> getSpecialReportResult() async {
    final report = ref.read(selectedSpecialReportProvider)!;
    final params = ref.read(paramsDataProvider);
    SpecialReportResult? result;
    GetSpecialReportResultUseCase getSpecialReportResultUsecase = GetSpecialReportResultUseCase();
    GetSpecialReportResultRequest getSpecialReportResultRequest = GetSpecialReportResultRequest(params: params, reportID: report.id);
    ref.read(specialReportResultProvider.notifier).update((state) => null);
    final fOrR = await getSpecialReportResultUsecase(request: getSpecialReportResultRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => getSpecialReportResult()), (r) {
      result = r.result;
      print("aaa");
      ref.read(specialReportResultProvider.notifier).update((state) => r.result);
    });
    return result;
  }

  void initSpecialReports() {
    ref.read(specialReportDataProvider.notifier).update((state) => null);
    ref.read(selectedSpecialReportProvider.notifier).update((state) => null);
    ref.read(specialReportResultProvider.notifier).update((state) => null);
    ref.read(specialReportOptionsProvider.notifier).update((state) => []);
    ref.read(paramsDataProvider.notifier).update((state) => {});
    getSpecialReportList();
  }

  Future<void> retrieveSpecialReportScreenFromLocalStorage() async {
    initSpecialReports();
  }

  /// Core ---------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    initSpecialReports();
    super.onInit();
  }
}
