import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/special_report_class.dart';

final specialReportsProvider = ChangeNotifierProvider<SpecialReportsState>((_) => SpecialReportsState());

class SpecialReportsState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool loading = false;
}

final specialReportDataProvider = StateProvider<SpecialReportData?>((ref) => null);
