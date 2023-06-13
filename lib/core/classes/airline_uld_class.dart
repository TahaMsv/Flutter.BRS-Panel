//
// import 'package:flutter/cupertino.dart';
//
// @immutable
// class TagContainer {
//   final int id;
//   final String type;
//   final String code;
//   final String barcode;
//
//   const TagContainer({
//     required this.id,
//     required this.type,
//     required this.code,
//     required this.barcode,
//   });
//
//   TagContainer copyWith({
//     int? id,
//     String? type,
//     String? code,
//     String? barcode,
//   }) =>
//       TagContainer(
//         id: id ?? this.id,
//         type: type ?? this.type,
//         code: code ?? this.code,
//         barcode: barcode ?? this.barcode,
//       );
//
//   factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
//     id: json["ID"]??0,
//     type: json["Type"]??json["ULDType"],
//     code: json["Code"],
//     barcode: json["Barcode"]??'',
//   );
//
//   Map<String, dynamic> toJson() => {
//     "ID": id,
//     "Type": type,
//     "Code": code,
//     "Barcode": barcode,
//   };
//
//   bool validateSearch(String s) {
//     return s.isEmpty || "$code$type".toLowerCase().contains(s.toLowerCase());
//   }
// }