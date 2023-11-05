import 'package:artemis_utils/artemis_utils.dart';
import 'package:artemis_utils/classes/hex_color.dart';
import 'package:flutter/material.dart';

import '../constants/abomis_pack_icons.dart';
import '../util/basic_class.dart';
import 'flight_details_class.dart';

class FlightSummary {
  FlightSummary({
    required this.flightScheduleId,
    required this.flightDate,
    required this.al,
    required this.flightNumber,
    required this.route,
    required this.std,
    required this.register,
    required this.positionSummaryList,
    required this.forcedTagList,
    required this.tagActionList,
    required this.binSummaryList,
    required this.exceptionTagList,
    required this.isFinalized,
    required this.missedTagList,
    required this.deletedTags,
  });

  int flightScheduleId;
  DateTime flightDate;
  String al;
  String flightNumber;
  String route;
  String std;
  String? register;
  List<PositionSummaryList> positionSummaryList;
  List<ForcedTagList> forcedTagList;
  List<MissedTag> missedTagList;
  List<TagActionList> tagActionList;
  List<BinSummaryList> binSummaryList;
  List<FlightTag> exceptionTagList;
  List<DeletedTag> deletedTags;
  bool isFinalized;

  factory FlightSummary.fromJson(Map<String, dynamic> json) => FlightSummary(
    flightScheduleId: json["FlightScheduleID"],
    flightDate: DateTime.parse(json["FlightDate"]),
    al: json["AL"],
    isFinalized: json["IsFinalized"] ?? false,
    flightNumber: json["FlightNumber"],
    route: json["Route"],
    std: json["STD"],
    register: json["Register"],
    positionSummaryList: List<PositionSummaryList>.from(json["PositionSummaryList"].map((x) => PositionSummaryList.fromJson(x))),
    forcedTagList: List<ForcedTagList>.from(json["ForcedTagList"].map((x) => ForcedTagList.fromJson(x))),
    missedTagList: List<MissedTag>.from((json["MissedTagList"] ?? []).map((x) => MissedTag.fromJson(x))),
    tagActionList: List<TagActionList>.from(json["TagActionList"].map((x) => TagActionList.fromJson(x))),
    binSummaryList: List<BinSummaryList>.from(json["BinSummaryList"].map((x) => BinSummaryList.fromJson(x))),
    exceptionTagList: List<FlightTag>.from(json["ExceptionTagList"].map((x) => FlightTag.fromJson(x))),
    deletedTags: List<DeletedTag>.from((json["DeletedTagList"] ?? []).map((x) => DeletedTag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "FlightScheduleID": flightScheduleId,
    "FlightDate": "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
    "AL": al,
    "FlightNumber": flightNumber,
    "Route": route,
    "STD": std,
    "Register": register,
    "IsFinalized": isFinalized,
    "PositionSummaryList": List<dynamic>.from(positionSummaryList.map((x) => x.toJson())),
    "ForcedTagList": List<dynamic>.from(forcedTagList.map((x) => x.toJson())),
    "MissedTagList": List<dynamic>.from(missedTagList.map((x) => x.toJson())),
    "TagActionList": List<dynamic>.from(tagActionList.map((x) => x.toJson())),
    "BinSummaryList": List<dynamic>.from(binSummaryList.map((x) => x.toJson())),
    "ExceptionTagList": List<dynamic>.from(exceptionTagList.map((x) => x.toJson())),
    "DeletedTagList": List<dynamic>.from(deletedTags.map((x) => x.toJson())),
  };
}

class DeletedTag {
  final int positionId;
  final String? positionTitle;
  final String? ignoredErrorText;
  final String? username;
  final String? tagNumber;
  final DateTime dateTimeUtc;

  DeletedTag({
    required this.positionId,
    required this.positionTitle,
    required this.ignoredErrorText,
    required this.username,
    required this.tagNumber,
    required this.dateTimeUtc,
  });

  DeletedTag copyWith({
    int? positionId,
    String? positionTitle,
    String? ignoredErrorText,
    String? username,
    String? tagNumber,
    DateTime? dateTimeUtc,
  }) =>
      DeletedTag(
        positionId: positionId ?? this.positionId,
        positionTitle: positionTitle ?? this.positionTitle,
        ignoredErrorText: ignoredErrorText ?? this.ignoredErrorText,
        username: username ?? this.username,
        tagNumber: tagNumber ?? this.tagNumber,
        dateTimeUtc: dateTimeUtc ?? this.dateTimeUtc,
      );

  factory DeletedTag.fromJson(Map<String, dynamic> json) => DeletedTag(
    positionId: json["PositionID"],
    positionTitle: json["PositionTitle"],
    ignoredErrorText: json["IgnoredErrorText"],
    username: json["Username"],
    tagNumber: json["TagNumber"],
    dateTimeUtc: DateTime.parse(json["DateTimeUTC"]),
  );

  Map<String, dynamic> toJson() => {
    "PositionID": positionId,
    "PositionTitle": positionTitle,
    "IgnoredErrorText": ignoredErrorText,
    "Username": username,
    "TagNumber": tagNumber,
    "DateTimeUTC": dateTimeUtc.toIso8601String(),
  };
}

class PositionSummaryList {
  PositionSummaryList({
    required this.id,
    required this.title,
    required this.color,
    required this.icon,
    required this.tagCount,
    required this.firstTagTimeUtc,
    required this.lastTagTimeUtc,
    required this.openTimeUtc,
    required this.closeTimeUtc,
  });

  int id;
  String title;
  String color;
  String icon;
  int tagCount;
  String? firstTagTimeUtc;
  String? lastTagTimeUtc;
  String? openTimeUtc;
  String? closeTimeUtc;

  factory PositionSummaryList.fromJson(Map<String, dynamic> json) => PositionSummaryList(
    id: json["ID"],
    title: json["Title"],
    color: json["Color"],
    icon: json["Icon"],
    tagCount: json["TagCount"],
    firstTagTimeUtc: json["FirstTagTimeUTC"],
    lastTagTimeUtc: json["LastTagTimeUTC"],
    openTimeUtc: json["OpenTimeUTC"],
    closeTimeUtc: json["CloseTimeUTC"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Title": title,
    "Color": color,
    "Icon": icon,
    "TagCount": tagCount,
    "FirstTagTimeUTC": firstTagTimeUtc,
    "LastTagTimeUTC": lastTagTimeUtc,
    "OpenTimeUTC": openTimeUtc,
    "CloseTimeUTC": closeTimeUtc,
  };

  bool get isOpen => openTimeUtc != null;

  bool get isClose => closeTimeUtc != null;

  IconData get iconData {
    return {
      1: AbomisIconPack.checkin,
      2: AbomisIconPack.baggageSort,
      3: AbomisIconPack.load,
      4: AbomisIconPack.unload,
      5: AbomisIconPack.transfer,
      6: AbomisIconPack.deliver,
    }[id] ??
        AbomisIconPack.info;
    // return DynamicIcons.fromValue(int.tryParse(icon)!);
  }

  Color get colorData => HexColor(color);
}

class ForcedTagList {
  ForcedTagList({
    required this.positionId,
    required this.positionTitle,
    required this.ignoredErrorText,
    required this.username,
    required this.tagNumber,
    required this.dateTimeUtc,
  });

  int positionId;
  String positionTitle;
  String ignoredErrorText;
  String username;
  String tagNumber;
  String dateTimeUtc;

  factory ForcedTagList.fromJson(Map<String, dynamic> json) => ForcedTagList(
    positionId: json["PositionID"],
    positionTitle: json["PositionTitle"],
    ignoredErrorText: json["IgnoredErrorText"],
    username: json["Username"],
    tagNumber: json["TagNumber"],
    dateTimeUtc: json["DateTimeUTC"],
  );

  Map<String, dynamic> toJson() => {
    "PositionID": positionId,
    "PositionTitle": positionTitle,
    "IgnoredErrorText": ignoredErrorText,
    "Username": username,
    "TagNumber": tagNumber,
    "DateTimeUTC": dateTimeUtc,
  };
}

class MissedTag {
  MissedTag({
    required this.positionId,
    required this.username,
    required this.tagNumber,
    required this.dateTimeUtc,
  });

  int positionId;
  String username;
  String tagNumber;
  String dateTimeUtc;

  factory MissedTag.fromJson(Map<String, dynamic> json) => MissedTag(
    positionId: json["PositionID"],
    username: json["Username"],
    tagNumber: json["TagNumber"],
    dateTimeUtc: json["DateTimeUTC"],
  );

  Map<String, dynamic> toJson() => {
    "PositionID": positionId,
    "Username": username,
    "TagNumber": tagNumber,
    "DateTimeUTC": dateTimeUtc,
  };

  DateTime get dt => DateTime.parse(dateTimeUtc).toLocal();

  String get dateTimeShow => BasicClass.getTimeFromUTC(dateTimeUtc.tryDateTimeUTC!).format_HHmmss;
}

class TagActionList {
  TagActionList({
    required this.positionId,
    required this.username,
    required this.tagNumber,
    required this.actionTitle,
    required this.dateTimeUtc,
  });

  int positionId;
  String username;
  String tagNumber;
  String actionTitle;
  String dateTimeUtc;

  factory TagActionList.fromJson(Map<String, dynamic> json) => TagActionList(
    positionId: json["PositionID"],
    username: json["Username"],
    tagNumber: json["TagNumber"],
    actionTitle: json["ActionTitle"],
    dateTimeUtc: json["DateTimeUTC"],
  );

  Map<String, dynamic> toJson() => {
    "PositionID": positionId,
    "Username": username,
    "TagNumber": tagNumber,
    "ActionTitle": actionTitle,
    "DateTimeUTC": dateTimeUtc,
  };
}

class BinSummaryList {
  BinSummaryList({
    required this.bin,
    required this.uldCount,
    required this.totalWeight,
    required this.tagCount,
    required this.hasULD,
  });

  String bin;
  int uldCount;
  int totalWeight;
  int tagCount;
  bool hasULD;

  factory BinSummaryList.fromJson(Map<String, dynamic> json) => BinSummaryList(
    bin: json["Bin"],
    uldCount: json["ULDCount"],
    totalWeight: json["TotalWeight"],
    tagCount: json["TagCount"],
    hasULD: json["HasULD"],
  );

  Map<String, dynamic> toJson() => {
    "Bin": bin,
    "ULDCount": uldCount,
    "TotalWeight": totalWeight,
    "TagCount": tagCount,
    "HasULD": hasULD,
  };
}