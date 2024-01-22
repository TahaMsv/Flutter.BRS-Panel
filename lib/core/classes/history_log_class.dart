class HistoryLog {
  final List<Log> flightLogs;
  final List<Log> tagLogs;
  final List<dynamic> userLogs;
  final List<dynamic> aiportLogs;

  HistoryLog({
    required this.flightLogs,
    required this.tagLogs,
    required this.userLogs,
    required this.aiportLogs,
  });

  HistoryLog copyWith({
    List<Log>? flightLogs,
    List<Log>? tagLogs,
    List<dynamic>? userLogs,
    List<dynamic>? aiportLogs,
  }) =>
      HistoryLog(
        flightLogs: flightLogs ?? this.flightLogs,
        tagLogs: tagLogs ?? this.tagLogs,
        userLogs: userLogs ?? this.userLogs,
        aiportLogs: aiportLogs ?? this.aiportLogs,
      );

  factory HistoryLog.fromJson(Map<String, dynamic> json) => HistoryLog(
        flightLogs: List<Log>.from(json["FlightLogs"].map((x) => Log.fromJson(x))),
        tagLogs: List<Log>.from(json["TagLogs"].map((x) => Log.fromJson(x))),
        userLogs: List<dynamic>.from(json["UserLogs"].map((x) => x)),
        aiportLogs: List<dynamic>.from(json["AiportLogs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "FlightLogs": List<dynamic>.from(flightLogs.map((x) => x.toJson())),
        "TagLogs": List<dynamic>.from(tagLogs.map((x) => x.toJson())),
        "UserLogs": List<dynamic>.from(userLogs.map((x) => x)),
        "AiportLogs": List<dynamic>.from(aiportLogs.map((x) => x)),
      };
}

class Log {
  final int id;
  final String actionType;
  final String userName;
  final String airport;
  final String flightNumber;
  final String? paxName;
  final String? tagNumber;
  final String? position;
  final String? section;
  final int? exceptionId;
  final String description;
  final String recordDatetimeUTC;
  final int? flightScheduleId;

  Log({
    required this.id,
    required this.actionType,
    required this.userName,
    required this.airport,
    required this.flightNumber,
    required this.paxName,
    required this.tagNumber,
    required this.position,
    required this.section,
    required this.exceptionId,
    required this.description,
    required this.recordDatetimeUTC,
    this.flightScheduleId,
  });

  Log copyWith({
    int? id,
    String? actionType,
    String? userName,
    String? airport,
    String? flightNumber,
    String? paxName,
    String? tagNumber,
    String? position,
    String? section,
    int? exceptionId,
    String? description,
    String? timeUtc,
    int? flightScheduleId,
  }) =>
      Log(
        id: id ?? this.id,
        actionType: actionType ?? this.actionType,
        userName: userName ?? this.userName,
        airport: airport ?? this.airport,
        flightNumber: flightNumber ?? this.flightNumber,
        paxName: paxName ?? this.paxName,
        tagNumber: tagNumber ?? this.tagNumber,
        position: position ?? this.position,
        section: section ?? this.section,
        exceptionId: exceptionId ?? this.exceptionId,
        description: description ?? this.description,
        recordDatetimeUTC: timeUtc ?? this.recordDatetimeUTC,
        flightScheduleId: flightScheduleId ?? this.flightScheduleId,
      );

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["ID"],
        actionType: json["ActionType"],
        userName: json["UserName"],
        airport: json["Airport"],
        flightNumber: json["FlightNumber"],
        paxName: json["PaxName"],
        tagNumber: json["TagNumber"],
        position: json["Position"],
        section: json["Section"],
        exceptionId: json["ExceptionID"],
        description: json["Description"] ?? "",
        recordDatetimeUTC: json["RecordDatetimeUTC"] ?? "",
        flightScheduleId: json["FlightScheduleID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ActionType": actionType,
        "UserName": userName,
        "Airport": airport,
        "FlightNumber": flightNumber,
        "PaxName": paxName,
        "TagNumber": tagNumber,
        "Position": position,
        "Section": section,
        "ExceptionID": exceptionId,
        "Description": description,
        "RecordDatetimeUTC": recordDatetimeUTC,
        "FlightScheduleID": flightScheduleId,
      };
}
