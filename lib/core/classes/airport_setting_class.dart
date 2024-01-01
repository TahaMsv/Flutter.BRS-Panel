// To parse this JSON data, do:   final airportSetting = airportSettingFromJson(jsonString);

import 'dart:convert';

AirportSetting airportSettingFromJson(String str) => AirportSetting.fromJson(json.decode(str));

String airportSettingToJson(AirportSetting data) => json.encode(data.toJson());

class AirportSetting {
  String airport;
  String name;
  String timeZone;
  int timeZoneDifference;
  List<Setting> defaultSetting;
  List<HandlingsOverride> handlingsOverride;

  AirportSetting({
    required this.airport,
    required this.name,
    required this.timeZone,
    required this.timeZoneDifference,
    required this.defaultSetting,
    required this.handlingsOverride,
  });

  factory AirportSetting.empty() => AirportSetting(airport: "", name: "", timeZone: "", timeZoneDifference: 0, defaultSetting: [], handlingsOverride: []);

  factory AirportSetting.fromJson(Map<String, dynamic> json) => AirportSetting(
        airport: json["Airport"],
        name: json["Name"],
        timeZone: json["TimeZone"],
        timeZoneDifference: json["TimeZoneDifference"],
        defaultSetting: List<Setting>.from(json["DefaultSetting"].map((x) => Setting.fromJson(x))),
        handlingsOverride: List<HandlingsOverride>.from(json["HandlingsOverride"].map((x) => HandlingsOverride.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Airport": airport,
        "Name": name,
        "TimeZone": timeZone,
        "TimeZoneDifference": timeZoneDifference,
        "DefaultSetting": List<dynamic>.from(defaultSetting.map((x) => x.toJson())),
        "HandlingsOverride": List<dynamic>.from(handlingsOverride.map((x) => x.toJson())),
      };
}

class Setting {
  int id;
  String key;
  String type;
  dynamic value;

  Setting({
    required this.id,
    required this.key,
    required this.type,
    required this.value,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["ID"],
        key: json["Key"],
        type: json["Type"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Key": key,
        "Type": type,
        "Value": value,
      };
}

class HandlingsOverride {
  int handlingId;
  List<Setting> setting;
  List<AirlineOverride> airlineOverride;

  HandlingsOverride({
    required this.handlingId,
    required this.setting,
    required this.airlineOverride,
  });

  factory HandlingsOverride.fromJson(Map<String, dynamic> json) => HandlingsOverride(
        handlingId: json["HandlingID"],
        setting: List<Setting>.from(json["Setting"].map((x) => Setting.fromJson(x))),
        airlineOverride: List<AirlineOverride>.from(json["AirlineOverride"].map((x) => AirlineOverride.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HandlingID": handlingId,
        "Setting": List<dynamic>.from(setting.map((x) => x.toJson())),
        "AirlineOverride": List<dynamic>.from(airlineOverride.map((x) => x.toJson())),
      };
}

class AirlineOverride {
  String al;
  List<Setting> setting;

  AirlineOverride({
    required this.al,
    required this.setting,
  });

  factory AirlineOverride.fromJson(Map<String, dynamic> json) => AirlineOverride(
        al: json["AL"],
        setting: List<Setting>.from(json["Setting"].map((x) => Setting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AL": al,
        "Setting": List<dynamic>.from(setting.map((x) => x.toJson())),
      };
}
