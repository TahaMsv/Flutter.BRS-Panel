import 'package:artemis_ui_kit/artemis_ui_kit.dart';
import 'package:flutter/material.dart';
import '../constants/abomis_pack_icons.dart';
import '../util/basic_class.dart';
import 'flight_details_class.dart';
import 'new_version_class.dart';
import 'tag_container_class.dart';

@immutable
class LoginUser {
  final String token;
  final String username;
  final String password;
  final NewVersion? newVersion;
  final bool rememberMe;
  final UserSettings userSettings;
  final SystemSettings systemSettings;

  const LoginUser({
    required this.token,
    required this.username,
    required this.password,
    required this.newVersion,
    required this.rememberMe,
    required this.userSettings,
    required this.systemSettings,
  });

  LoginUser copyWith({
    String? token,
    String? username,
    String? password,
    NewVersion? newVersion,
    bool? rememberMe,
    UserSettings? userSettings,
    SystemSettings? systemSettings,
  }) =>
      LoginUser(
        token: token ?? this.token,
        username: username ?? this.username,
        password: password ?? this.password,
        newVersion: newVersion ?? this.newVersion,
        rememberMe: rememberMe ?? this.rememberMe,
        userSettings: userSettings ?? this.userSettings,
        systemSettings: systemSettings ?? this.systemSettings,
      );

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        token: json["Token"],
        newVersion: json["NewVersion"] == null ? null : NewVersion.fromJson(json["NewVersion"]),
        rememberMe: json["RememberMe"],
        userSettings: UserSettings.fromJson(json["UserSettings"]),
        systemSettings: SystemSettings.fromJson(json["SystemSettings"]),
        username: json["Username"] ?? '',
        password: json["Password"] ?? '',
      );

  factory LoginUser.empty() => LoginUser(
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
  final List<TagAction> actions;
  final List<TagContainer> containers;
  final List<TagStatus> statusList;
  final List<TagAction> exceptionStatusList;
  final List<TagAction> exceptionActionList;
  final List<ClassType> classTypeList;
  final List<HandlingSetting> handlingSetting;
  final List<HandlingAccess> handlingAccess;
  final List<Airport> airportList;

  // final List<Airline> airlineList;
  final List<Aircraft> aircraftList;
  final List<TagType> tagTypeList;

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
    // required this.airlineList,
    required this.airportList,
    required this.aircraftList,
    required this.tagTypeList,
  });

  SystemSettings copyWith({
    List<Position>? positions,
    List<TagAction>? actions,
    List<TagContainer>? containers,
    List<String>? barcodeTypes,
    BarcodeSetting? barcodeSetting,
    List<ErrorList>? errorList,
    List<TagStatus>? statusList,
    List<ZplList>? zplList,
    List<TagAction>? exceptionStatusList,
    List<TagAction>? exceptionActionList,
    List<ClassType>? classTypeList,
    List<AirlineRouteSetting>? airlineRouteSetting,
    List<HandlingSetting>? handlingSetting,
    List<HandlingAccess>? handlingAccess,
    List<Airport>? airportList,
    List<Aircraft>? aircraftList,
    // List<Airline>? airlineList,
    List<TagType>? tagTypeList,
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
        // airlineList: airlineList ?? this.airlineList,
        tagTypeList: tagTypeList ?? this.tagTypeList,
      );

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        positions: List<Position>.from(json["Positions"].map((x) => Position.fromJson(x))),
        actions: List<TagAction>.from((json["Actions2"] ?? []).map((x) => TagAction.fromJson(x))),
        containers: List<TagContainer>.from(json["Containers"].map((x) => TagContainer.fromJson(x))),
        statusList: List<TagStatus>.from(json["StatusList"].map((x) => TagStatus.fromJson(x))),
        exceptionStatusList: List<TagAction>.from((json["ExceptionStatusList2"] ?? []).map((x) => TagAction.fromJson(x))),
        exceptionActionList: List<TagAction>.from((json["ExceptionActionList2"] ?? []).map((x) => TagAction.fromJson(x))),
        classTypeList: List<ClassType>.from(json["ClassTypeList"].map((x) => ClassType.fromJson(x))),
        handlingSetting: List<HandlingSetting>.from(json["HandlingSetting"].map((x) => HandlingSetting.fromJson(x))),
        handlingAccess: List<HandlingAccess>.from(json["HandlingAccess"].map((x) => HandlingAccess.fromJson(x))),
        // airlineList: List<Airline>.from((json["AirlineList2"] ?? []).map((x) => Airline.fromJson(x))),
        airportList: List<Airport>.from(json["AirportList"].map((x) => Airport.fromJson(x))),
        aircraftList: List<Aircraft>.from(((json["AircraftList"] ?? [])).map((x) => Aircraft.fromJson(x))),
        tagTypeList: List<TagType>.from((json["TagTypeList"] ?? []).map((x) => TagType.fromJson(x))),
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
        // "AirlineList": List<dynamic>.from(airlineList.map((x) => x.toJson())),
        "AircraftList": List<dynamic>.from(aircraftList.map((x) => x.toJson())),
        "TagTypeList": List<dynamic>.from(tagTypeList.map((x) => x.toJson())),
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
      handlingAccess: [],
      // airlineList: [],
      airportList: [],
      aircraftList: [],
      tagTypeList: [],
    );
  }
}

@immutable
class TagAction {
  final int id;
  final String actionTitle;
  final int position;
  final String color;
  final String description;
  final String title;
  final String icon;

  const TagAction({
    required this.id,
    required this.actionTitle,
    required this.position,
    required this.color,
    required this.description,
    required this.title,
    required this.icon,
  });

  Color get getColor => HexColor(color);

  TagAction copyWith({
    int? id,
    String? actionTitle,
    int? position,
    String? color,
    String? description,
    String? title,
    String? icon,
  }) =>
      TagAction(
        id: id ?? this.id,
        actionTitle: actionTitle ?? this.actionTitle,
        position: position ?? this.position,
        color: color ?? this.color,
        description: description ?? this.description,
        title: title ?? this.title,
        icon: icon ?? this.icon,
      );

  factory TagAction.fromJson(Map<String, dynamic> json) => TagAction(
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

  int? get colorValue => int.tryParse(color);

  int? get iconValue => int.tryParse(icon);

  Color get getColor => id == 0 ? Colors.green : HexColor(color);

  IconData? get getIcon {
    return {
      0: null,
      1: AbomisIconPack.denyLoad,
      2: AbomisIconPack.search,
      3: AbomisIconPack.task,
      4: AbomisIconPack.lock,
    }[id];
    // return int.tryParse(icon) == null ? null : DynamicIcons.fromValue(int.tryParse(icon)!);
  }
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

  int? get colorValue => int.tryParse(color);

  Color get getColor => HexColor(color);
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

  // final List<PositionAction> actions;

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
    // required this.actions,
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
    // List<PositionAction>? actions,
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
        // actions: actions ?? this.actions,
      );

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json["ID"],
      title: json["Title"],
      binRequired: json["BinRequired"],
      containerRequired: json["ContainerRequired"],
      transferFlightRequired: json["TransferFlightRequired"],
      order: json["Order"],
      containerAction: json["ContainerAction"],
      color: json["Color"],
      icon: json["Icon"],

      // actions: List<PositionAction>.from(json["Actions"].map((x) => PositionAction.fromJson(x))),
    );
  }

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
        // "Actions": List<dynamic>.from(actions.map((x) => x.toJson())),
      };

  Color get getColor => HexColor(color);

  IconData? get posIcon {
    return {
      1: AbomisIconPack.checkin,
      2: AbomisIconPack.baggageSort,
      3: AbomisIconPack.load,
      4: AbomisIconPack.unload,
      5: AbomisIconPack.transfer,
      6: AbomisIconPack.deliver,
    }[id];
    // return icon == null
    //     ? null
    //     : int.tryParse(icon!) == null
    //         ? null
    //         : DynamicIcons.fromValue(int.tryParse(icon!)!);
  }

  IconData? get getIcon => posIcon;
}

// @immutable
// class PositionAction {
//   final int id;
//
//   const PositionAction({
//     required this.id,
//   });
//
//   PositionAction copyWith({
//     int? id,
//   }) =>
//       PositionAction(
//         id: id ?? this.id,
//       );
//
//   factory PositionAction.fromJson(Map<String, dynamic> json) => PositionAction(
//         id: json["ID"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "ID": id,
//       };
// }

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

class PositionSection {
  final String title;
  final int offset;
  final int count;
  final String color;
  final String title;

  PositionSection({
    required this.title,
    required this.offset,
    required this.count,
    required this.color,
    required this.title,
  });

  PositionSection copyWith({
    String? title,
    int? offset,
    int? count,
    String? color,
    String? title,
  }) =>
      PositionSection(
        title: title ?? this.title,
        offset: offset ?? this.offset,
        count: count ?? this.count,
        color: color ?? this.color,
        title: title ?? this.title,
      );

  factory PositionSection.fromJson(Map<String, dynamic> json) => PositionSection(
        title: json["Title"] ?? "TST",
        offset: json["Offset"],
        count: json["Count"],
        color: json["Color"] ?? "0a1a82",
        title: json["Title"] ?? "TST",
      );

  Color get getColor => HexColor(color);

  String get value => "$count";

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Offset": offset,
        "Count": count,
        "Color": color,
        "Title": title,
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
  final List<HomepageList> homepageList;
  final List<Shoot> shootList;
  final List<String> accessAirlines;
  final List<AirportPositionSection> hierarchy;

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
    required this.homepageList,
    required this.shootList,
    required this.accessAirlines,
    required this.hierarchy,
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
    List<HomepageList>? homepageList,
    List<Shoot>? shootList,
    List<String>? accessAirlines,
    List<AirportPositionSection>? hierarchy,
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
        homepageList: homepageList ?? this.homepageList,
        shootList: shootList ?? this.shootList,
        hierarchy: hierarchy ?? this.hierarchy,
        accessAirlines: accessAirlines ?? this.accessAirlines,
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
        accessAirlines: List<String>.from((json["AccessAirlines"] ?? []).map((e) => e["AL"])),
        hierarchy: List<AirportPositionSection>.from((json["AirportPositionSections"] ?? []).map((x) => AirportPositionSection.fromJson(x))),
        homepageList: List<HomepageList>.from(json["HomepageList"].map((x) => HomepageList.fromJson(x))),
        shootList: List<Shoot>.from((json["ShootList"] ?? []).map((x) => Shoot.fromJson(x))),
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
        "HomepageList": List<dynamic>.from(homepageList.map((x) => x.toJson())),
        "AirportPositionSections": List<dynamic>.from(hierarchy.map((x) => x.toJson())),
        "ShootList": List<dynamic>.from(shootList.map((x) => x.toJson())),
        "AccessAirlines": accessAirlines.map((e) => {"AL": e}).toList(),
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
      homepageList: [],
      shootList: [],
      accessAirlines: [],
      hierarchy: [],
    );
  }
}

class HomepageList {
  final int id;
  final String title;

  HomepageList({
    required this.id,
    required this.title,
  });

  HomepageList copyWith({
    int? id,
    String? title,
  }) =>
      HomepageList(
        id: id ?? this.id,
        title: title ?? this.title,
      );

  factory HomepageList.fromJson(Map<String, dynamic> json) => HomepageList(
        id: json["ID"],
        title: json["Title"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Title": title,
      };
}

class AirportPositionSection {
  final int id;
  final String label;
  final int position;
  final int offset;

  // final bool isMainSection;
  final bool canHaveTag;

  // final List<AirportPositionSection> sub1;
  // final List<AirportPositionSection> sub2;
  // final List<AirportPositionSection> sub3;
  final List<AirportPositionSection> subs;
  final String? address;
  final String? color;
  final int count;
  final int lvl;
  final bool canHaveContainer;
  final bool canHaveBin;
  final bool spotRequired;

  AirportPositionSection({
    required this.id,
    required this.label,
    required this.position,
    required this.offset,
    // required this.isMainSection,
    required this.canHaveTag,
    required this.subs,
    this.count = 0,
    this.address,
    this.color,
    this.lvl = 0,
    required this.canHaveContainer,
    required this.canHaveBin,
    required this.spotRequired,
  });

  Position? get getPosition => BasicClass.getPositionById(position);

  bool get hasSub => !canHaveTag;

  Color get getColor => HexColor(color ?? "FFFFFF");

  AirportPositionSection copyWith({
    int? id,
    String? label,
    int? position,
    int? offset,
    bool? isMainSection,
    bool? canHaveTag,
    // List<AirportPositionSection>? sub1,
    // List<AirportPositionSection>? sub2,
    // List<AirportPositionSection>? sub3,
    List<AirportPositionSection>? subs,
    String? address,
    int? count,
    int? lvl,
    bool? canHaveContainer,
    bool? spotRequired,
    bool? canHaveBin,
  }) =>
      AirportPositionSection(
        id: id ?? this.id,
        label: label ?? this.label,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        // isMainSection: isMainSection ?? this.isMainSection,
        canHaveTag: canHaveTag ?? this.canHaveTag,
        // sub1: sub1 ?? this.sub1,
        // sub2: sub2 ?? this.sub2,
        // sub3: sub1 ?? this.sub3,
        subs: subs ?? this.subs,
        address: address ?? this.address,
        count: count ?? this.count,
        lvl: lvl ?? this.lvl,
        canHaveContainer: canHaveContainer ?? this.canHaveContainer,
        canHaveBin: canHaveBin ?? this.canHaveBin,
        spotRequired: spotRequired ?? this.spotRequired,
      );

  factory AirportPositionSection.fromJson(Map<String, dynamic> json) => AirportPositionSection(
        id: json["ID"] ?? 0,
        label: json["Label"] ?? '',
        position: json["Position"] ?? 1,
        offset: json["Offset"],
        // isMainSection: json["IsMainSection"]??false,
        canHaveTag: json["CanHaveTag"] ?? false,
        // sub1: List<AirportPositionSection>.from((json["SUB1"] ?? []).map((x) => AirportPositionSection.fromJson(x))),
        // sub2: List<AirportPositionSection>.from((json["SUB2"] ?? []).map((x) => AirportPositionSection.fromJson(x))),
        // sub3: List<AirportPositionSection>.from((json["SUB3"] ?? []).map((x) => AirportPositionSection.fromJson(x))),
        subs: List<AirportPositionSection>.from(
            (json.entries.firstWhere((element) => element.key.startsWith("SUB"), orElse: () => MapEntry("SUB", [])).value).map((x) => AirportPositionSection.fromJson(x))),
        address: json["Address"],
        count: json["Count"] ?? 0,
        lvl: json["LVL"] ?? 0,
        spotRequired: json["SpotRequired"] ?? false,
        canHaveContainer: json["CanHaveContainer"] ?? false,
        canHaveBin: json["CanHaveBin"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Position": position,
        "Offset": offset,
        // "IsMainSection": isMainSection,
        "CanHaveTag": canHaveTag,
        // "SUB1": List<dynamic>.from(sub1.map((x) => x.toJson())),
        // "SUB2": List<dynamic>.from(sub2.map((x) => x.toJson())),
        // "SUB3": List<dynamic>.from(sub3.map((x) => x.toJson())),
        "SUBS": List<dynamic>.from(subs.map((x) => x.toJson())),
        "Address": address,
        "Count": count,
        "LVL": lvl,
        "CanHaveContainer": canHaveContainer,
        "CanHaveBin": canHaveBin,
        "SpotRequired": spotRequired,
      };

  bool get isMainSection => true;

  List<int> get subsIds {
    return hierSections.map((e) => e.id).toList();
  }

  List<AirportPositionSection> get hierSections {
    List<AirportPositionSection> hier = [this];
    hier = hier + subSections;
    return hier;
  }

  List<AirportPositionSection> get firstSubs {
    List<AirportPositionSection> hier = [];
    hier = subs;
    return hier;
  }

  List<AirportPositionSection> get subSections {
    List<AirportPositionSection> hier = [this.copyWith(address: "", lvl: 1)];
    // print("${label} EMMPTY SUBS:${subs.isEmpty}");
    if (subs.isEmpty) return hier;
    subs.forEach((s) {
      // print("$label-->/***${s.label}=> subSections: ${s.subSections.length}");
      hier = hier + s.subSections.map((e) => e.copyWith(address: "$label/${e.address}", lvl: e.lvl + 1)).toList();
    });
    // print("${label}=> subSections: ${hier.length}");
    return hier;
  }

  // List<AirportPositionSection> get subSections {
  //   List<AirportPositionSection> hier = [];
  //   (sub1 + sub2 + sub3).forEach((s1) {
  //     hier.add(s1);
  //     (s1.sub1 + s1.sub2 + s1.sub3).forEach((s2) {
  //       hier.add(s2);
  //       (s2.sub1 + s2.sub2 + s2.sub3).forEach((s3) {
  //         hier.add(s3);
  //       });
  //     });
  //   });
  //   return hier;
  // }

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return (other is AirportPositionSection && other.id == id);
    // return (other is TagContainer && other.typeId == typeId && other.code.toLowerCase() == code.toLowerCase());
    // return super == other;
  }

  List<FlightTag> getTags(FlightDetails fd, {Position? pos}) {
    return fd.tagList.where((element) => (pos == null || element.currentPosition == pos.id) && subsIds.contains(element.sectionID)).toList();
  }

  List<Bin> getBins(FlightDetails fd, {Position? pos}) {
    return fd.binList.where((element) => subsIds.contains(element.sectionID)).toList();
  }

  List<TagContainer> getCons(FlightDetails fd, {Position? pos}) {
    return fd.containerList.where((element) => subsIds.contains(element.sectionID)).toList();
  }

  bool hasAnyThing(FlightDetails fd, {Position? pos}) => canHaveBin || getTags(fd, pos: pos).isNotEmpty || getBins(fd, pos: pos).isNotEmpty || getCons(fd, pos: pos).isNotEmpty;

  IconData get getIcon {
    // if (icon != null) return DynamicIcons.fromValue(int.tryParse(icon!)!);

    return {
          1: AbomisIconPack.SBPP,
          2: AbomisIconPack.pax,
          3: AbomisIconPack.checkin,
          4: AbomisIconPack.convoyer,
          5: AbomisIconPack.baggageSort,
          6: AbomisIconPack.sortArea,
          7: AbomisIconPack.ramp,
          8: AbomisIconPack.jetway,
          9: AbomisIconPack.loadingArea,
          10: AbomisIconPack.aircraft,
          11: AbomisIconPack.unload,
          12: AbomisIconPack.transfer,
          13: AbomisIconPack.transfer,
        }[id] ??
        AbomisIconPack.info;
    return AbomisIconPack.arrivals;
  }

// int get count => 0;

  bool get showEmpty => (label == "Checkin") || (label.contains("Deliver")) || (label == "Aircraft" && position == 4) || true;
}

class Shoot {
  final int id;
  final String airport;
  final String title;
  final List<Spot> spotList;

  Shoot({
    required this.id,
    required this.airport,
    required this.title,
    required this.spotList,
  });

  Shoot copyWith({
    int? id,
    String? airport,
    String? title,
    List<Spot>? spotList,
  }) =>
      Shoot(
        id: id ?? this.id,
        airport: airport ?? this.airport,
        title: title ?? this.title,
        spotList: spotList ?? this.spotList,
      );

  factory Shoot.fromJson(Map<String, dynamic> json) => Shoot(
        id: json["ID"],
        airport: json["Airport"],
        title: json["Title"],
        spotList: List<Spot>.from(json["SpotList"].map((x) => Spot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Airport": airport,
        "Title": title,
        "SpotList": List<dynamic>.from(spotList.map((x) => x.toJson())),
      };
}

class Spot {
  final int id;
  final String spot;
  final String barcode;
  final int? containerId;

  Spot({
    required this.id,
    required this.spot,
    required this.barcode,
    required this.containerId,
  });

  Spot copyWith({
    int? id,
    String? spot,
    String? barcode,
    int? containerId,
  }) =>
      Spot(
        id: id ?? this.id,
        spot: spot ?? this.spot,
        barcode: barcode ?? this.barcode,
        containerId: containerId ?? this.containerId,
      );

  factory Spot.fromJson(Map<String, dynamic> json) => Spot(
        id: json["ID"],
        spot: json["Spot"],
        barcode: json["Barcode"],
        containerId: json["ContainerId"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Spot": spot,
        "Barcode": barcode,
        "containerID": containerId,
      };

  String get label => spot;
}

@immutable
class Aircraft {
  final int id;
  final String al;
  final String registration;
  final String aircraftType;
  final List<Bin> bins;
  final bool isDeleted;

  const Aircraft({
    required this.id,
    required this.al,
    required this.registration,
    required this.aircraftType,
    required this.bins,
    this.isDeleted = false,
  });

  Aircraft copyWith({
    int? id,
    String? al,
    String? registration,
    String? aircraftType,
    List<Bin>? bins,
    bool? isDeleted,
  }) =>
      Aircraft(
          id: id ?? this.id,
          aircraftType: aircraftType ?? this.aircraftType,
          al: al ?? this.al,
          registration: registration ?? this.registration,
          bins: bins ?? this.bins,
          isDeleted: isDeleted ?? this.isDeleted);

  factory Aircraft.empty() => const Aircraft(id: 0, al: '', registration: '', aircraftType: '', bins: []);

  factory Aircraft.fromJson(Map<String, dynamic> json) => Aircraft(
        id: json["ID"],
        aircraftType: json["Type"] ?? '',
        al: json["AL"],
        isDeleted: json["IsDeleted"] ?? false,
        registration: json["Registration"],
        bins: List<Bin>.from((json["Bins"] ?? []).map((x) => Bin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Type": aircraftType,
        "AL": al,
        "Registration": registration,
        "IsDeleted": isDeleted,
        "Bins": List<dynamic>.from(bins.map((x) => x.toJson())),
      };

  bool validateSearch(String s) {
    return s.trim().isEmpty || "$registration $al".toLowerCase().contains(s.toLowerCase());
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
        name: json["Name"] ?? '',
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
  final String cityName;
  final String strTimeZone;
  final int timeZone;

  const Airport({
    required this.code,
    required this.cityName,
    required this.strTimeZone,
    required this.timeZone,
  });

  Airport copyWith({
    String? code,
    String? cityName,
    String? strTimeZone,
    int? timeZone,
  }) =>
      Airport(
        code: code ?? this.code,
        cityName: cityName ?? this.cityName,
        strTimeZone: strTimeZone ?? this.strTimeZone,
        timeZone: timeZone ?? this.timeZone,
      );

  factory Airport.empty() => const Airport(code: "", cityName: "", strTimeZone: "", timeZone: 0);

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
        code: json["Code"],
        cityName: json["CityName"],
        strTimeZone: json["STRTimeZone"],
        timeZone: json["TimeZone"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "CityName": cityName,
        "STRTimeZone": strTimeZone,
        "TimeZone": timeZone,
      };

  validateSearch(String s) {
    return s.isEmpty || "$code $cityName".toLowerCase().contains(s.toLowerCase());
  }
}

class TagType {
  final int id;
  final String label;
  final String color;
  final String textColor;
  final String? al;

  TagType({
    required this.id,
    required this.label,
    required this.color,
    required this.textColor,
    required this.al,
  });

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return other is TagType && other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  Color get getColor => HexColor(color);

  Color get getTextColor => HexColor(textColor);

  TagType copyWith({
    int? id,
    String? code,
    String? color,
    String? textColor,
    String? al,
  }) =>
      TagType(
        id: id ?? this.id,
        label: code ?? this.label,
        color: color ?? this.color,
        textColor: textColor ?? this.textColor,
        al: al ?? this.al,
      );

  factory TagType.fromJson(Map<String, dynamic> json) => TagType(
        id: json["ID"],
        label: json["Label"],
        al: json["AL"],
        color: json["Color"] ?? '000000',
        textColor: json["TextColor"] ?? 'FFFFFF',
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Al": al,
        "Color": color,
        "TextColor": textColor,
      };
}
