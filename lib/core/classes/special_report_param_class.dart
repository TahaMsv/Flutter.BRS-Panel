
import 'package:brs_panel/core/util/string_utils.dart';

import 'special_report_param_option_class.dart';

class SpecialReportParam {
  final int id;
  final String label;
  final String type;

  SpecialReportParam({
    required this.id,
    required this.label,
    required this.type,
  });

  SpecialReportParam copyWith({
    int? id,
    String? label,
    String? type,
  }) =>
      SpecialReportParam(
        id: id ?? this.id,
        label: label ?? this.label,
        type: type ?? this.type,
      );

  factory SpecialReportParam.fromJson(Map<String, dynamic> json) => SpecialReportParam(
        id: json["ID"],
        label: json["Label"],
        type: json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Type": type,
      };

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
