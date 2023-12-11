import 'package:brs_panel/core/classes/special_report_result_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/special_report_class.dart';
import '../../core/classes/special_report_data_class.dart';
import '../../core/classes/special_report_param_class.dart';
import '../../core/classes/special_report_param_option_class.dart';

final specialReportsProvider = ChangeNotifierProvider<SpecialReportsState>((_) => SpecialReportsState());

class SpecialReportsState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool loading = false;

}

final specialReportDataProvider = StateProvider<SpecialReportData?>((ref) => null);
final selectedSpecialReportProvider = StateProvider<SpecialReport?>((ref) => null);
final specialReportOptionsProvider = StateProvider<List<SpecialReportParameterOptions>>((ref) => []);
final paramsDataProvider = StateProvider<Map<SpecialReportParam, ParamOption>>((ref) => {});
final specialReportResultProvider = StateProvider<SpecialReportResult?>((ref) => null);

final loadingSpecialReportDataProvider = StateProvider<bool>((ref) => false);
final loadingParamsOptionsProvider = StateProvider<bool>((ref) => false);
