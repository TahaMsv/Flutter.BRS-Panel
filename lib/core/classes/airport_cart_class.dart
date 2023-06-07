import 'package:flutter/cupertino.dart';

@immutable
class AirportCart {
  final int id;
  final String type;
  final String code;
  final String barcode;

  const AirportCart({
    required this.id,
    required this.type,
    required this.code,
    required this.barcode,
  });

  AirportCart copyWith({
    int? id,
    String? type,
    String? code,
    String? barcode,
  }) =>
      AirportCart(
        id: id ?? this.id,
        type: type ?? this.type,
        code: code ?? this.code,
        barcode: barcode ?? this.barcode,
      );

  factory AirportCart.fromJson(Map<String, dynamic> json) => AirportCart(
    id: json["ID"],
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
    return s.isEmpty || "$type$code".toLowerCase().contains(s.toLowerCase());
  }
}
