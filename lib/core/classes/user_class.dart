import 'package:flutter/cupertino.dart';
import 'package:get/utils.dart';
import '../platform/encryptor.dart';

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
    required this.isSavePassword,
    required this.password,
    required this.accessType,
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
  final bool isSavePassword;
  final int? handlingID;
  final int? accessType;

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
    bool? isSavePassword,
    int? handlingID,
    int? accessType,
  }) =>
      User(
        id: id ?? this.id,
        accessType: accessType ?? this.accessType,
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
        isSavePassword: isSavePassword ?? this.isSavePassword,
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
        accessType: json["AccessType"] ?? 1,
        isHandlingAdmin: json["IsHandlingAdmin"] ?? false,
    isSavePassword: json["IsSavePassword"] ?? false,
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
      isSavePassword: false,
      accessType: 1,
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
        "AccessType": accessType,
        "IsHandlingAdmin": isHandlingAdmin,
        "IsSavePassword": isSavePassword,
      };

  String? encryptPassword() {
    if (password == null) return null;
    return Encryptor.encryptPassword(password!);
  }

  validateSearch(String searched) {
    return ("$username $name $al $alCode".toLowerCase().contains(searched.toLowerCase()) || searched == "");
  }
}


enum UserAccessType {
  agent,
  supervisor,
  admin
}

extension UserAccessTypeDetails on UserAccessType {
  int get id {
    switch (this){
      case UserAccessType.agent:
       return 1;
      case UserAccessType.supervisor:
       return 2;
      case UserAccessType.admin:
       return 3;
    }
  }
  String? get label {
   return name.capitalizeFirst;
  }
}