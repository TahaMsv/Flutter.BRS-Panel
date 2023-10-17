class TagMoreDetails {
  FlightInfo? flightInfo;
  List<TagPhoto> tagPhotos;
  List<TagLog> logs;
  final List<Bsm> bsmList;

  TagMoreDetails({
    required this.flightInfo,
    required this.tagPhotos,
    required this.logs,
    required this.bsmList,
  });

  factory TagMoreDetails.fromJson(Map<String, dynamic> json) => TagMoreDetails(
    flightInfo: FlightInfo.fromJson(json["FlightInfo"]),
    tagPhotos: List<TagPhoto>.from(json["Photos"].map((e) => TagPhoto.fromJson(e))).toList(),
    logs: List<TagLog>.from((json["Logs"] ?? []).map((x) => TagLog.fromJson(x))),
    bsmList: List<Bsm>.from(json["BSMList"].map((x) => Bsm.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "FlightInfo": flightInfo?.toJson(),
    "Photos": tagPhotos.map((e) => e.toJson()).toList(),
    "Logs": List<dynamic>.from(logs.map((x) => x.toJson())),
    "BSMList": List<dynamic>.from(bsmList.map((x) => x.toJson())),
  };
}

class TagLog {
  final String title;

  TagLog({
    required this.title,
  });

  TagLog copyWith({
    String? title,
  }) =>
      TagLog(
        title: title ?? this.title,
      );

  factory TagLog.fromJson(Map<String, dynamic> json) => TagLog(
    title: json["Title"],
  );

  Map<String, dynamic> toJson() => {
    "Title": title,
  };
}

class Bsm {
  final int sortOrder;
  final String bsmMessage;
  final DateTime bsmTime;

  Bsm({
    required this.sortOrder,
    required this.bsmMessage,
    required this.bsmTime,
  });

  Bsm copyWith({
    int? sortOrder,
    String? bsmMessage,
    DateTime? bsmTime,
  }) =>
      Bsm(
        sortOrder: sortOrder ?? this.sortOrder,
        bsmMessage: bsmMessage ?? this.bsmMessage,
        bsmTime: bsmTime ?? this.bsmTime,
      );

  factory Bsm.fromJson(Map<String, dynamic> json) => Bsm(
    sortOrder: json["SortOrder"],
    bsmMessage: json["BSMMessage"],
    bsmTime: DateTime.parse(json["BSMTime"]),
  );

  Map<String, dynamic> toJson() => {
    "SortOrder": sortOrder,
    "BSMMessage": bsmMessage,
    "BSMTime": bsmTime.toIso8601String(),
  };
}

class FlightInfo {
  FlightInfo({
    required this.flightScheduleId,
    required this.flightDate,
    required this.al,
    required this.flightNumber,
    required this.route,
    required this.std,
    required this.register,
    required this.isFinalized,
  });

  int flightScheduleId;
  DateTime flightDate;
  String al;
  String flightNumber;
  String route;
  String std;
  String? register;
  bool isFinalized;

  factory FlightInfo.fromJson(Map<String, dynamic> json) => FlightInfo(
    flightScheduleId: json["FlightScheduleID"],
    flightDate: DateTime.parse(json["FlightDate"]),
    al: json["AL"],
    isFinalized: json["isFinalized"] ?? false,
    flightNumber: json["FlightNumber"],
    route: json["Route"],
    std: json["STD"],
    register: json["Register"],
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
  };
}

class TagPhoto {
  TagPhoto({
    required this.tag,
    required this.photo,
    required this.positionID,
  });

  String tag;
  int positionID;
  String photo;

  factory TagPhoto.fromJson(Map<String, dynamic> json) => TagPhoto(
    tag: json["Tag"],
    photo: json["Photo"],
    positionID: json["PositionID"],
  );

  Map<String, dynamic> toJson() => {
    "Tag": tag,
    "Photo": photo,
    "PositionID": positionID,
  };
}
