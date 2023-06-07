
import 'package:flutter/cupertino.dart';

@immutable
class AirlineUld {
  final int id;
  final String type;
  final String code;
  final String barcode;

  const AirlineUld({
    required this.id,
    required this.type,
    required this.code,
    required this.barcode,
  });

  AirlineUld copyWith({
    int? id,
    String? type,
    String? code,
    String? barcode,
  }) =>
      AirlineUld(
        id: id ?? this.id,
        type: type ?? this.type,
        code: code ?? this.code,
        barcode: barcode ?? this.barcode,
      );

  factory AirlineUld.fromJson(Map<String, dynamic> json) => AirlineUld(
    id: json["ID"]??0,
    type: json["Type"],
    code: json["Code"],
    barcode: json["Barcode"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Type": type,
    "Code": code,
    "Barcode": barcode,
  };

  bool validateSearch(String s) {
    return s.isEmpty || "$code$type".toLowerCase().contains(s.toLowerCase());
  }
}