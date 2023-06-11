import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'flight_details_class.dart';
import 'new_version_class.dart';

@immutable
class User {
  final String token;
  final String username;
  final String password;
  final NewVersion? newVersion;
  final bool rememberMe;
  final UserSettings userSettings;
  final SystemSettings systemSettings;

  const User({
    required this.token,
    required this.username,
    required this.password,
    required this.newVersion,
    required this.rememberMe,
    required this.userSettings,
    required this.systemSettings,
  });

  User copyWith({
    String? token,
    String? username,
    String? password,
    NewVersion? newVersion,
    bool? rememberMe,
    UserSettings? userSettings,
    SystemSettings? systemSettings,
  }) =>
      User(
        token: token ?? this.token,
        username: username ?? this.username,
        password: password ?? this.password,
        newVersion: newVersion ?? this.newVersion,
        rememberMe: rememberMe ?? this.rememberMe,
        userSettings: userSettings ?? this.userSettings,
        systemSettings: systemSettings ?? this.systemSettings,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["Token"],
        newVersion: json["NewVersion"] == null ? null : NewVersion.fromJson(json["NewVersion"]),
        rememberMe: json["RememberMe"],
        userSettings: UserSettings.fromJson(json["UserSettings"]),
        systemSettings: SystemSettings.fromJson(json["SystemSettings"]),
        username: json["Username"] ?? '',
        password: json["Password"] ?? '',
      );

  factory User.empty() => User(
        token: "token",
        newVersion: null,
        rememberMe: false,
        userSettings: UserSettings.empty(),
        systemSettings: SystemSettings.empty(),
        username: '',
        password: '',
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Username": username,
        "Password": password,
        "NewVersion": newVersion?.toJson(),
        "RememberMe": rememberMe,
        "UserSettings": userSettings.toJson(),
        "SystemSettings": systemSettings.toJson(),
      };
}

@immutable
class SystemSettings {
  final List<Position> positions;
  final List<Action> actions;
  final List<TagContainer> containers;
  final List<TagStatus> statusList;
  final List<Action> exceptionStatusList;
  final List<Action> exceptionActionList;
  final List<ClassType> classTypeList;
  final List<HandlingSetting> handlingSetting;
  final List<HandlingAccess> handlingAccess;
  final List<Airport> airportList;
  final List<Airline> airlineList;
  final List<Aircraft> aircraftList;

  const SystemSettings({
    required this.positions,
    required this.actions,
    required this.containers,
    required this.statusList,
    required this.exceptionStatusList,
    required this.exceptionActionList,
    required this.classTypeList,
    required this.handlingSetting,
    required this.handlingAccess,
    required this.airlineList,
    required this.airportList,
    required this.aircraftList,
  });

  SystemSettings copyWith({
    List<Position>? positions,
    List<Action>? actions,
    List<TagContainer>? containers,
    List<String>? barcodeTypes,
    BarcodeSetting? barcodeSetting,
    List<ErrorList>? errorList,
    List<TagStatus>? statusList,
    List<ZplList>? zplList,
    List<Action>? exceptionStatusList,
    List<Action>? exceptionActionList,
    List<ClassType>? classTypeList,
    List<AirlineRouteSetting>? airlineRouteSetting,
    List<HandlingSetting>? handlingSetting,
    List<HandlingAccess>? handlingAccess,
    List<Airport>? airportList,
    List<Aircraft>? aircraftList,
    List<Airline>? airlineList,
  }) =>
      SystemSettings(
        positions: positions ?? this.positions,
        actions: actions ?? this.actions,
        containers: containers ?? this.containers,
        statusList: statusList ?? this.statusList,
        exceptionStatusList: exceptionStatusList ?? this.exceptionStatusList,
        exceptionActionList: exceptionActionList ?? this.exceptionActionList,
        classTypeList: classTypeList ?? this.classTypeList,
        handlingSetting: handlingSetting ?? this.handlingSetting,
        handlingAccess: handlingAccess ?? this.handlingAccess,
        aircraftList: aircraftList ?? this.aircraftList,
        airportList: airportList ?? this.airportList,
        airlineList: airlineList ?? this.airlineList,
      );

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        positions: List<Position>.from(json["Positions"].map((x) => Position.fromJson(x))),
        actions: List<Action>.from(json["Actions"].map((x) => Action.fromJson(x))),
        containers: List<TagContainer>.from(json["Containers"].map((x) => TagContainer.fromJson(x))),
        statusList: List<TagStatus>.from(json["StatusList"].map((x) => TagStatus.fromJson(x))),
        exceptionStatusList: List<Action>.from(json["ExceptionStatusList"].map((x) => Action.fromJson(x))),
        exceptionActionList: List<Action>.from(json["ExceptionActionList"].map((x) => Action.fromJson(x))),
        classTypeList: List<ClassType>.from(json["ClassTypeList"].map((x) => ClassType.fromJson(x))),
        handlingSetting: List<HandlingSetting>.from(json["HandlingSetting"].map((x) => HandlingSetting.fromJson(x))),
        handlingAccess: List<HandlingAccess>.from(json["HandlingAccess"].map((x) => HandlingAccess.fromJson(x))),
        airlineList: List<Airline>.from(json["AirlineList"].map((x) => Airline.fromJson(x))),
        airportList: List<Airport>.from(json["AirportList"].map((x) => Airport.fromJson(x))),
        aircraftList: List<Aircraft>.from(json["AircraftList"].map((x) => Aircraft.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Positions": List<dynamic>.from(positions.map((x) => x.toJson())),
        "Actions": List<dynamic>.from(actions.map((x) => x.toJson())),
        "Containers": List<dynamic>.from(containers.map((x) => x.toJson())),
        "StatusList": List<dynamic>.from(statusList.map((x) => x.toJson())),
        "ExceptionStatusList": List<dynamic>.from(exceptionStatusList.map((x) => x.toJson())),
        "ExceptionActionList": List<dynamic>.from(exceptionActionList.map((x) => x.toJson())),
        "ClassTypeList": List<dynamic>.from(classTypeList.map((x) => x.toJson())),
        "HandlingSetting": List<dynamic>.from(handlingSetting.map((x) => x.toJson())),
        "HandlingAccess": List<dynamic>.from(handlingAccess.map((x) => x.toJson())),
        "AirportList": List<dynamic>.from(airportList.map((x) => x.toJson())),
        "AirlineList": List<dynamic>.from(airlineList.map((x) => x.toJson())),
        "AircraftList": List<dynamic>.from(aircraftList.map((x) => x.toJson())),
      };

  factory SystemSettings.empty() {
    return const SystemSettings(
      positions: [],
      actions: [],
      containers: [],
      statusList: [],
      exceptionStatusList: [],
      exceptionActionList: [],
      classTypeList: [],
      handlingSetting: [],
      handlingAccess: [], airlineList: [], airportList: [], aircraftList: [],
    );
  }
}

@immutable
class Action {
  final int id;
  final String actionTitle;
  final int position;
  final String color;
  final String description;
  final String title;
  final String icon;

  const Action({
    required this.id,
    required this.actionTitle,
    required this.position,
    required this.color,
    required this.description,
    required this.title,
    required this.icon,
  });

  Action copyWith({
    int? id,
    String? actionTitle,
    int? position,
    String? color,
    String? description,
    String? title,
    String? icon,
  }) =>
      Action(
        id: id ?? this.id,
        actionTitle: actionTitle ?? this.actionTitle,
        position: position ?? this.position,
        color: color ?? this.color,
        description: description ?? this.description,
        title: title ?? this.title,
        icon: icon ?? this.icon,
      );

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        id: json["ID"],
        actionTitle: json["ActionTitle"] ?? '',
        position: json["Position"] ?? 0,
        color: json["Color"] ?? '',
        description: json["Description"] ?? '',
        title: json["Title"] ?? '',
        icon: json["Icon"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ActionTitle": actionTitle,
        "Position": position,
        "Color": color,
        "Description": description,
        "Title": title,
        "Icon": icon,
      };
}

@immutable
class TagStatus {
  final int id;
  final String actionTitle;
  final int position;
  final String color;
  final String description;
  final String title;
  final String icon;

  const TagStatus({
    required this.id,
    required this.actionTitle,
    required this.position,
    required this.color,
    required this.description,
    required this.title,
    required this.icon,
  });

  TagStatus copyWith({
    int? id,
    String? actionTitle,
    int? position,
    String? color,
    String? description,
    String? title,
    String? icon,
  }) =>
      TagStatus(
        id: id ?? this.id,
        actionTitle: actionTitle ?? this.actionTitle,
        position: position ?? this.position,
        color: color ?? this.color,
        description: description ?? this.description,
        title: title ?? this.title,
        icon: icon ?? this.icon,
      );

  factory TagStatus.fromJson(Map<String, dynamic> json) => TagStatus(
        id: json["ID"],
        actionTitle: json["ActionTitle"] ?? '',
        position: json["Position"] ?? 0,
        color: json["Color"] ?? '',
        description: json["Description"] ?? '',
        title: json["Title"] ?? '',
        icon: json["Icon"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ActionTitle": actionTitle,
        "Position": position,
        "Color": color,
        "Description": description,
        "Title": title,
        "Icon": icon,
      };
}

@immutable
class AirlineRouteSetting {
  final String al;
  final String airport;
  final int barcodeLength;
  final String alCode;
  final bool tagOnlyDigit;
  final String regex;
  final String regexExample;

  const AirlineRouteSetting({
    required this.al,
    required this.airport,
    required this.barcodeLength,
    required this.alCode,
    required this.tagOnlyDigit,
    required this.regex,
    required this.regexExample,
  });

  AirlineRouteSetting copyWith({
    String? al,
    String? airport,
    int? barcodeLength,
    String? alCode,
    bool? tagOnlyDigit,
    String? regex,
    String? regexExample,
  }) =>
      AirlineRouteSetting(
        al: al ?? this.al,
        airport: airport ?? this.airport,
        barcodeLength: barcodeLength ?? this.barcodeLength,
        alCode: alCode ?? this.alCode,
        tagOnlyDigit: tagOnlyDigit ?? this.tagOnlyDigit,
        regex: regex ?? this.regex,
        regexExample: regexExample ?? this.regexExample,
      );

  factory AirlineRouteSetting.fromJson(Map<String, dynamic> json) => AirlineRouteSetting(
        al: json["AL"],
        airport: json["Airport"],
        barcodeLength: json["BarcodeLength"],
        alCode: json["ALCode"],
        tagOnlyDigit: json["TagOnlyDigit"],
        regex: json["Regex"],
        regexExample: json["RegexExample"],
      );

  Map<String, dynamic> toJson() => {
        "AL": al,
        "Airport": airport,
        "BarcodeLength": barcodeLength,
        "ALCode": alCode,
        "TagOnlyDigit": tagOnlyDigit,
        "Regex": regex,
        "RegexExample": regexExample,
      };
}

@immutable
class BarcodeSetting {
  final String? barcodeTypeDeparture;
  final String? barcodeTypeArrival;
  final int barcodeLengthDeparture;
  final int barcodeLengthArrival;

  const BarcodeSetting({
    required this.barcodeTypeDeparture,
    required this.barcodeTypeArrival,
    required this.barcodeLengthDeparture,
    required this.barcodeLengthArrival,
  });

  BarcodeSetting copyWith({
    String? barcodeTypeDeparture,
    String? barcodeTypeArrival,
    int? barcodeLengthDeparture,
    int? barcodeLengthArrival,
  }) =>
      BarcodeSetting(
        barcodeTypeDeparture: barcodeTypeDeparture ?? this.barcodeTypeDeparture,
        barcodeTypeArrival: barcodeTypeArrival ?? this.barcodeTypeArrival,
        barcodeLengthDeparture: barcodeLengthDeparture ?? this.barcodeLengthDeparture,
        barcodeLengthArrival: barcodeLengthArrival ?? this.barcodeLengthArrival,
      );

  factory BarcodeSetting.fromJson(Map<String, dynamic> json) => BarcodeSetting(
        barcodeTypeDeparture: json["BarcodeTypeDeparture"],
        barcodeTypeArrival: json["BarcodeTypeArrival"],
        barcodeLengthDeparture: json["BarcodeLengthDeparture"],
        barcodeLengthArrival: json["BarcodeLengthArrival"],
      );

  Map<String, dynamic> toJson() => {
        "BarcodeTypeDeparture": barcodeTypeDeparture,
        "BarcodeTypeArrival": barcodeTypeArrival,
        "BarcodeLengthDeparture": barcodeLengthDeparture,
        "BarcodeLengthArrival": barcodeLengthArrival,
      };

  factory BarcodeSetting.empty() => const BarcodeSetting(
        barcodeTypeDeparture: null,
        barcodeTypeArrival: null,
        barcodeLengthDeparture: 10,
        barcodeLengthArrival: 10,
      );
}

@immutable
class ClassType {
  final int id;
  final String title;
  final String color;
  final String segregation;
  final String abbreviation;

  const ClassType({
    required this.id,
    required this.title,
    required this.color,
    required this.segregation,
    required this.abbreviation,
  });

  ClassType copyWith({
    int? id,
    String? title,
    String? color,
    String? segregation,
    String? abbreviation,
  }) =>
      ClassType(
        id: id ?? this.id,
        title: title ?? this.title,
        color: color ?? this.color,
        segregation: segregation ?? this.segregation,
        abbreviation: abbreviation ?? this.abbreviation,
      );

  factory ClassType.fromJson(Map<String, dynamic> json) => ClassType(
        id: json["ID"],
        title: json["Title"],
        color: json["Color"],
        segregation: json["Segregation"],
        abbreviation: json["Abbreviation"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Title": title,
        "Color": color,
        "Segregation": segregation,
        "Abbreviation": abbreviation,
      };
}
//
// @immutable
// class TagContainer {
//   final int id;
//   final int typeId;
//   final String title;
//   final String barcodePrefix;
//
//   const TagContainer({
//     required this.id,
//     required this.typeId,
//     required this.title,
//     required this.barcodePrefix,
//   });
//
//   TagContainer copyWith({
//     int? id,
//     int? typeId,
//     String? title,
//     String? barcodePrefix,
//   }) =>
//       TagContainer(
//         id: id ?? this.id,
//         typeId: typeId ?? this.typeId,
//         title: title ?? this.title,
//         barcodePrefix: barcodePrefix ?? this.barcodePrefix,
//       );
//
//   factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
//         id: json["ID"]??1,
//         typeId: json["TypeID"],
//         title: json["Title"],
//         barcodePrefix: json["BarcodePrefix"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "ID": id,
//         "TypeID": typeId,
//         "Title": title,
//         "BarcodePrefix": barcodePrefix,
//       };
// }

@immutable
class ErrorList {
  final int code;
  final String message;

  const ErrorList({
    required this.code,
    required this.message,
  });

  ErrorList copyWith({
    int? code,
    String? message,
  }) =>
      ErrorList(
        code: code ?? this.code,
        message: message ?? this.message,
      );

  factory ErrorList.fromJson(Map<String, dynamic> json) => ErrorList(
        code: json["Code"],
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
      };
}

@immutable
class HandlingAccess {
  final int id;
  final String name;

  const HandlingAccess({
    required this.id,
    required this.name,
  });

  HandlingAccess copyWith({
    int? id,
    String? name,
  }) =>
      HandlingAccess(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory HandlingAccess.fromJson(Map<String, dynamic> json) => HandlingAccess(
        id: json["ID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
      };
}

@immutable
class HandlingSetting {
  final int handlingId;
  final String handlingName;
  final List<Airline> airlines;

  const HandlingSetting({
    required this.handlingId,
    required this.handlingName,
    required this.airlines,
  });

  HandlingSetting copyWith({
    int? handlingId,
    String? handlingName,
    List<Airline>? airlines,
  }) =>
      HandlingSetting(
        handlingId: handlingId ?? this.handlingId,
        handlingName: handlingName ?? this.handlingName,
        airlines: airlines ?? this.airlines,
      );

  factory HandlingSetting.fromJson(Map<String, dynamic> json) => HandlingSetting(
        handlingId: json["HandlingID"],
        handlingName: json["HandlingName"],
        airlines: List<Airline>.from(json["Airlines"].map((x) => Airline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HandlingID": handlingId,
        "HandlingName": handlingName,
        "Airlines": List<dynamic>.from(airlines.map((x) => x.toJson())),
      };
}


@immutable
class Position {
  final int id;
  final String title;
  final bool binRequired;
  final bool containerRequired;
  final bool transferFlightRequired;
  final int order;
  final bool containerAction;
  final String color;
  final String icon;
  final List<PositionAction> actions;

  const Position({
    required this.id,
    required this.title,
    required this.binRequired,
    required this.containerRequired,
    required this.transferFlightRequired,
    required this.order,
    required this.containerAction,
    required this.color,
    required this.icon,
    required this.actions,
  });

  Position copyWith({
    int? id,
    String? title,
    bool? binRequired,
    bool? containerRequired,
    bool? transferFlightRequired,
    int? order,
    bool? containerAction,
    String? color,
    String? icon,
    List<PositionAction>? actions,
  }) =>
      Position(
        id: id ?? this.id,
        title: title ?? this.title,
        binRequired: binRequired ?? this.binRequired,
        containerRequired: containerRequired ?? this.containerRequired,
        transferFlightRequired: transferFlightRequired ?? this.transferFlightRequired,
        order: order ?? this.order,
        containerAction: containerAction ?? this.containerAction,
        color: color ?? this.color,
        icon: icon ?? this.icon,
        actions: actions ?? this.actions,
      );

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        id: json["ID"],
        title: json["Title"],
        binRequired: json["BinRequired"],
        containerRequired: json["ContainerRequired"],
        transferFlightRequired: json["TransferFlightRequired"],
        order: json["Order"],
        containerAction: json["ContainerAction"],
        color: json["Color"],
        icon: json["Icon"],
        actions: List<PositionAction>.from(json["Actions"].map((x) => PositionAction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Title": title,
        "BinRequired": binRequired,
        "ContainerRequired": containerRequired,
        "TransferFlightRequired": transferFlightRequired,
        "Order": order,
        "ContainerAction": containerAction,
        "Color": color,
        "Icon": icon,
        "Actions": List<dynamic>.from(actions.map((x) => x.toJson())),
      };

  Color get getColor => HexColor(color);
  IconData? get getIcon => Icons.h_mobiledata;
}

@immutable
class PositionAction {
  final int id;

  const PositionAction({
    required this.id,
  });

  PositionAction copyWith({
    int? id,
  }) =>
      PositionAction(
        id: id ?? this.id,
      );

  factory PositionAction.fromJson(Map<String, dynamic> json) => PositionAction(
        id: json["ID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
      };
}

@immutable
class RealAlarmSetting {
  final String greenLight;
  final String redLight;
  final String orangeLight;
  final String beepOn;
  final String beepOff;
  final int blinkInterval;

  const RealAlarmSetting({
    required this.greenLight,
    required this.redLight,
    required this.orangeLight,
    required this.beepOn,
    required this.beepOff,
    required this.blinkInterval,
  });

  RealAlarmSetting copyWith({
    String? greenLight,
    String? redLight,
    String? orangeLight,
    String? beepOn,
    String? beepOff,
    int? blinkInterval,
  }) =>
      RealAlarmSetting(
        greenLight: greenLight ?? this.greenLight,
        redLight: redLight ?? this.redLight,
        orangeLight: orangeLight ?? this.orangeLight,
        beepOn: beepOn ?? this.beepOn,
        beepOff: beepOff ?? this.beepOff,
        blinkInterval: blinkInterval ?? this.blinkInterval,
      );

  factory RealAlarmSetting.fromJson(Map<String, dynamic> json) => RealAlarmSetting(
        greenLight: json["GreenLight"],
        redLight: json["RedLight"],
        orangeLight: json["OrangeLight"],
        beepOn: json["BeepOn"],
        beepOff: json["BeepOff"],
        blinkInterval: json["BlinkInterval"],
      );

  Map<String, dynamic> toJson() => {
        "GreenLight": greenLight,
        "RedLight": redLight,
        "OrangeLight": orangeLight,
        "BeepOn": beepOn,
        "BeepOff": beepOff,
        "BlinkInterval": blinkInterval,
      };

  factory RealAlarmSetting.empty() {
    return const RealAlarmSetting(
      greenLight: "greenLight",
      redLight: "redLight",
      orangeLight: "orangeLight",
      beepOn: "beepOn",
      beepOff: "beepOff",
      blinkInterval: 1,
    );
  }
}

@immutable
class ZplList {
  final int id;
  final String type;
  final String zpl;
  final String description;

  const ZplList({
    required this.id,
    required this.type,
    required this.zpl,
    required this.description,
  });

  ZplList copyWith({
    int? id,
    String? type,
    String? zpl,
    String? description,
  }) =>
      ZplList(
        id: id ?? this.id,
        type: type ?? this.type,
        zpl: zpl ?? this.zpl,
        description: description ?? this.description,
      );

  factory ZplList.fromJson(Map<String, dynamic> json) => ZplList(
        id: json["ID"],
        type: json["Type"],
        zpl: json["ZPL"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Type": type,
        "ZPL": zpl,
        "Description": description,
      };
}

@immutable
class UserSettings {
  final int id;
  final String airport;
  final String al;
  final int barcodeLength;
  final String alCode;
  final int waitSecondMin;
  final int waitSecondMax;
  final bool tagOnlyDigit;
  final bool isAdmin;
  final int deadlineThreshold;

  const UserSettings({
    required this.id,
    required this.airport,
    required this.al,
    required this.barcodeLength,
    required this.alCode,
    required this.waitSecondMin,
    required this.waitSecondMax,
    required this.tagOnlyDigit,
    required this.isAdmin,
    required this.deadlineThreshold,
  });

  UserSettings copyWith({
    int? id,
    String? airport,
    String? al,
    int? barcodeLength,
    String? alCode,
    int? waitSecondMin,
    int? waitSecondMax,
    bool? tagOnlyDigit,
    bool? isAdmin,
    int? deadlineThreshold,
  }) =>
      UserSettings(
        id: id ?? this.id,
        airport: airport ?? this.airport,
        al: al ?? this.al,
        barcodeLength: barcodeLength ?? this.barcodeLength,
        alCode: alCode ?? this.alCode,
        waitSecondMin: waitSecondMin ?? this.waitSecondMin,
        waitSecondMax: waitSecondMax ?? this.waitSecondMax,
        tagOnlyDigit: tagOnlyDigit ?? this.tagOnlyDigit,
        isAdmin: isAdmin ?? this.isAdmin,
        deadlineThreshold: deadlineThreshold ?? this.deadlineThreshold,
      );

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        id: json["ID"],
        airport: json["Airport"],
        al: json["AL"],
        barcodeLength: json["BarcodeLength"],
        alCode: json["ALCode"],
        waitSecondMin: json["WaitSecond_Min"],
        waitSecondMax: json["WaitSecond_Max"],
        tagOnlyDigit: json["TagOnlyDigit"],
        isAdmin: json["IsAdmin"],
        deadlineThreshold: json["DeadlineThreshold"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Airport": airport,
        "AL": al,
        "BarcodeLength": barcodeLength,
        "ALCode": alCode,
        "WaitSecond_Min": waitSecondMin,
        "WaitSecond_Max": waitSecondMax,
        "TagOnlyDigit": tagOnlyDigit,
        "IsAdmin": isAdmin,
        "DeadlineThreshold": deadlineThreshold,
      };

  factory UserSettings.empty() {
    return const UserSettings(
      id: 1,
      airport: "",
      al: "",
      barcodeLength: 10,
      alCode: "000",
      waitSecondMin: 3,
      waitSecondMax: 6,
      tagOnlyDigit: true,
      isAdmin: false,
      deadlineThreshold: 30,
    );
  }
}

@immutable
class Aircraft {
  final int id;
  final String al;
  final String registration;

  const Aircraft({
    required this.id,
    required this.al,
    required this.registration,
  });

  Aircraft copyWith({
    int? id,
    String? al,
    String? registration,
  }) =>
      Aircraft(
        id: id ?? this.id,
        al: al ?? this.al,
        registration: registration ?? this.registration,
      );

  factory Aircraft.fromJson(Map<String, dynamic> json) => Aircraft(
        id: json["ID"],
        al: json["AL"],
        registration: json["Registration"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "AL": al,
        "Registration": registration,
      };

  bool validateSearch(String s) {
    return s.isEmpty || "$registration $al".toLowerCase().contains(s.toLowerCase());
  }
}

@immutable
class Airline {
  final String al;
  final String name;

  const Airline({
    required this.al,
    required this.name,
  });

  Airline copyWith({
    String? al,
    String? name,
  }) =>
      Airline(
        al: al ?? this.al,
        name: name ?? this.name,
      );

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        al: json["AL"],
        name: json["Name"]??'',
      );

  Map<String, dynamic> toJson() => {
        "AL": al,
        "Name": name,
      };

  bool validateSearch(String s) {
    return s.isEmpty || "$al $name".toLowerCase().contains(s.toLowerCase());
  }
}

@immutable
class Airport {
  final String code;
  final String name;

  const Airport({
    required this.code,
    required this.name,
  });

  Airport copyWith({
    String? code,
    String? name,
  }) =>
      Airport(
        code: code ?? this.code,
        name: name ?? this.name,
      );

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
        code: json["Code"],
        name: json["Name"]??'',
      );
  

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };

  bool validateSearch(String s) {
    return s.isEmpty || "$code $name".toLowerCase().contains(s.toLowerCase());
  }
}
