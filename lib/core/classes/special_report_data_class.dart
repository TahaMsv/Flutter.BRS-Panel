
import 'package:brs_panel/core/classes/special_report_class.dart';
import 'package:flutter/cupertino.dart';

import 'special_report_param_class.dart';

@immutable
class SpecialReportData {
  final List<SpecialReport> reportList;
  final List<SpecialReportParam> parameters;

  const SpecialReportData({
    required this.reportList,
    required this.parameters,
  });

  SpecialReportData copyWith({
    List<SpecialReport>? reportList,
    List<SpecialReportParam>? parameters,
  }) =>
      SpecialReportData(
        reportList: reportList ?? this.reportList,
        parameters: parameters ?? this.parameters,
      );

  factory SpecialReportData.fromJson(Map<String, dynamic> json) => SpecialReportData(
    reportList: List<SpecialReport>.from(json["ReportList"].map((x) => SpecialReport.fromJson(x))),
    parameters: List<SpecialReportParam>.from(json["Parameters"].map((x) => SpecialReportParam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ReportList": List<dynamic>.from(reportList.map((x) => x.toJson())),
    "Parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
  };
}

