import 'package:brs_panel/core/util/string_utils.dart';
import 'package:flutter/material.dart';

@immutable
class SpecialReportData {
  final List<SpecialReport> reportList;
  final List<SpecialReportParam> parameters;

  const SpecialReportData({required this.reportList, required this.parameters});

  SpecialReportData copyWith({List<SpecialReport>? reportList, List<SpecialReportParam>? parameters}) =>
      SpecialReportData(reportList: reportList ?? this.reportList, parameters: parameters ?? this.parameters);

  factory SpecialReportData.fromJson(Map<String, dynamic> json) => SpecialReportData(
        reportList: List<SpecialReport>.from(json["ReportList"].map((x) => SpecialReport.fromJson(x))),
        parameters: List<SpecialReportParam>.from(json["Parameters"].map((x) => SpecialReportParam.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ReportList": List<dynamic>.from(reportList.map((x) => x.toJson())),
        "Parameters": List<dynamic>.from(parameters.map((x) => x.toJson())),
      };
}

@immutable
class SpecialReport {
  final int id;
  final String label;
  final String parameters;

  const SpecialReport({required this.id, required this.label, required this.parameters});

  SpecialReport copyWith({int? id, String? label, String? parameters}) =>
      SpecialReport(id: id ?? this.id, label: label ?? this.label, parameters: parameters ?? this.parameters);

  factory SpecialReport.fromJson(Map<String, dynamic> json) =>
      SpecialReport(id: json["ID"], label: json["Label"], parameters: json["Parameters"]);

  Map<String, dynamic> toJson() => {"ID": id, "Label": label, "Parameters": parameters};

  List<int> get getParameters => parameters.split(",").map((e) => int.parse(e)).toList();
}

class SpecialReportParam {
  final int id;
  final String label;
  final String type;

  SpecialReportParam({required this.id, required this.label, required this.type});

  SpecialReportParam copyWith({int? id, String? label, String? type}) =>
      SpecialReportParam(id: id ?? this.id, label: label ?? this.label, type: type ?? this.type);

  factory SpecialReportParam.fromJson(Map<String, dynamic> json) =>
      SpecialReportParam(id: json["ID"], label: json["Label"], type: json["Type"]);

  Map<String, dynamic> toJson() => {"ID": id, "Label": label, "Type": type};

  SpecialReportParamTypes get getType => SpecialReportParamTypes.values.firstWhere((element) => element.label == type);
}

enum SpecialReportParamTypes { date, time, number, text, dropDown, checkBox }

extension SpecialReportParamTypesDetails on SpecialReportParamTypes {
  String get label {
    switch (this) {
      case SpecialReportParamTypes.date:
        return "Date";
      case SpecialReportParamTypes.time:
        return "Time";
      case SpecialReportParamTypes.number:
        return "Number";
      case SpecialReportParamTypes.text:
        return "Text";
      case SpecialReportParamTypes.dropDown:
        return "DropDown";
      case SpecialReportParamTypes.checkBox:
        return "CheckBox";
    }
  }

  ParamOption get initialValue {
    switch (this) {
      case SpecialReportParamTypes.date:
        return ParamOption(value: DateTime.now().formatyyyyMMdd, label: label);
      case SpecialReportParamTypes.time:
        return ParamOption(value: DateTime.now().formathhmm, label: label);
      case SpecialReportParamTypes.number:
        return ParamOption(value: null, label: label);
      case SpecialReportParamTypes.text:
        return ParamOption(value: null, label: label);
      case SpecialReportParamTypes.dropDown:
        return ParamOption(value: null, label: label);
      case SpecialReportParamTypes.checkBox:
        return ParamOption(value: false, label: label);
    }
  }
}

class ParamOption {
  final dynamic value;
  final String label;

  ParamOption({required this.value, required this.label});

  ParamOption copyWith({dynamic value, String? label}) =>
      ParamOption(value: value ?? this.value, label: label ?? this.label);

  factory ParamOption.fromJson(Map<String, dynamic> json) => ParamOption(value: json["Value"], label: json["Label"]);

  Map<String, dynamic> toJson() => {"Value": value, "Label": label};
}
