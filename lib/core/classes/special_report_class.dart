



import 'package:flutter/cupertino.dart';

@immutable
class SpecialReport {
  final int id;
  final String label;
  final String parameters;

  SpecialReport({
    required this.id,
    required this.label,
    required this.parameters,
  });

  SpecialReport copyWith({
    int? id,
    String? label,
    String? parameters,
  }) =>
      SpecialReport(
        id: id ?? this.id,
        label: label ?? this.label,
        parameters: parameters ?? this.parameters,
      );

  factory SpecialReport.fromJson(Map<String, dynamic> json) => SpecialReport(
    id: json["ID"],
    label: json["Label"],
    parameters: json["Parameters"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Label": label,
    "Parameters": parameters,
  };


  List<int> get getParameters => parameters.split(",").map((e) => int.parse(e)).toList();
}