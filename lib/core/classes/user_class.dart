import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.username,
    required this.name,
    required this.airport,
    required this.al,
    required this.barcodeLength,
    required this.alCode,
    required this.waitSecondMin,
    required this.waitSecondMax,
    required this.tagOnlyDigit,
    required this.isAdmin,
    required this.handlingID,
    required this.isHandlingAdmin,
    required this.password,
  });

  final int id;
  final String username;
  final String name;
  final String airport;
  final String al;
  final int barcodeLength;
  final String alCode;
  final String? password;
  final int waitSecondMin;
  final int waitSecondMax;
  final bool tagOnlyDigit;
  final bool isAdmin;
  final bool isHandlingAdmin;
  final int? handlingID;

  User copyWith({
    int? id,
    String? username,
    String? name,
    String? airport,
    String? al,
    int? barcodeLength,
    String? alCode,
    String? password,
    int? waitSecondMin,
    int? waitSecondMax,
    bool? tagOnlyDigit,
    bool? isAdmin,
    bool? isHandlingAdmin,
    int? handlingID,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        name: name ?? this.name,
        airport: airport ?? this.airport,
        al: al ?? this.al,
        barcodeLength: barcodeLength ?? this.barcodeLength,
        alCode: alCode ?? this.alCode,
        password: password ?? this.password,
        waitSecondMin: waitSecondMin ?? this.waitSecondMin,
        waitSecondMax: waitSecondMax ?? this.waitSecondMax,
        tagOnlyDigit: tagOnlyDigit ?? this.tagOnlyDigit,
        isAdmin: isAdmin ?? this.isAdmin,
        isHandlingAdmin: isHandlingAdmin ?? this.isHandlingAdmin,
        handlingID: handlingID ?? this.handlingID,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["UserID"],
        username: json["Username"],
        name: json["Name"],
        airport: json["Airport"],
        al: json["AL"],
        barcodeLength: json["BarcodeLength"],
        alCode: json["ALCode"] ?? "000",
        waitSecondMin: json["WaitSecondMin"],
        waitSecondMax: json["WaitSecondMax"],
        tagOnlyDigit: json["TagOnlyDigit"],
        isAdmin: json["IsAdmin"],
        password: json["Password"],
        handlingID: json["HandlingID"] ?? 0,
        isHandlingAdmin: json["IsHandlingAdmin"] ?? false,
      );

  factory User.empty() => const User(
      id: 1,
      username: "",
      name: "",
      airport: "",
      al: "",
      barcodeLength: 10,
      alCode: "000",
      password: "",
      waitSecondMin: 3,
      waitSecondMax: 6,
      tagOnlyDigit: true,
      isAdmin: false,
      isHandlingAdmin: false,
      handlingID: null);

  Map<String, dynamic> toJson() => {
        "UserID": id,
        "Username": username,
        "Name": name,
        "Airport": airport,
        "AL": al,
        "BarcodeLength": barcodeLength,
        "ALCode": alCode,
        "WaitSecondMin": waitSecondMin,
        "WaitSecondMax": waitSecondMax,
        "TagOnlyDigit": tagOnlyDigit,
        "IsAdmin": isAdmin,
        "Password": encryptPassword(),
        "HandlingID": handlingID,
        "IsHandlingAdmin": isHandlingAdmin,
      };

  String? encryptPassword() {
    if (password == null) return null;
    List<int> passwordBytes = utf8.encode(password!);
    String passwordEncrypted = sha256.convert(passwordBytes).toString();
    return passwordEncrypted;
  }

  validateSearch(String searched) {
    return ("$username $name $al $alCode".toLowerCase().contains(searched.toLowerCase()) || searched == "");
  }
}
