class SpecialReportParameterOptions {
  final int id;
  final List<ParamOption> options;

  SpecialReportParameterOptions({
    required this.id,
    required this.options,
  });

  SpecialReportParameterOptions copyWith({
    int? id,
    List<ParamOption>? options,
  }) =>
      SpecialReportParameterOptions(
        id: id ?? this.id,
        options: options ?? this.options,
      );

  factory SpecialReportParameterOptions.fromJson(Map<String, dynamic> json) => SpecialReportParameterOptions(
    id: json["ID"],
    options: List<ParamOption>.from(json["Options"].map((x) => ParamOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class ParamOption {
  final dynamic value;
  final String label;

  ParamOption({
    required this.value,
    required this.label,
  });

  ParamOption copyWith({
    dynamic value,
    String? label,
  }) =>
      ParamOption(
        value: value ?? this.value,
        label: label ?? this.label,
      );

  factory ParamOption.fromJson(Map<String, dynamic> json) => ParamOption(
    value: json["Value"],
    label: json["Label"]??'-',
  );

  Map<String, dynamic> toJson() => {
    "Value": value,
    "Label": label,
  };
}