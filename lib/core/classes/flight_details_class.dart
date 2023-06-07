import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:flutter/material.dart';

import '../util/basic_class.dart';
import 'user_class.dart';

class FlightDetails {
  FlightDetails({
    required this.flightScheduleId,
    required this.tagList,
    required this.wrongTagList,
    required this.containerList,
    required this.baggageAverageWeight,
    required this.weightUnit,
    required this.transferFlightList,
    required this.binList,
  });

  int flightScheduleId;
  String weightUnit;
  int baggageAverageWeight;
  List<FlightTag> tagList;
  List<WrongTag> wrongTagList;
  List<TagContainer> containerList;
  List<TransferFlight> transferFlightList;
  List<Bin> binList;

  factory FlightDetails.fromJson(Map<String, dynamic> json) {
    return FlightDetails(
      flightScheduleId: json["FlightScheduleID"],
      baggageAverageWeight: json["BaggageAverageWeight"] ?? 15,
      weightUnit: json["WeightUnit"] ?? "KG",
      tagList: List<FlightTag>.from(json["TagList"].map((x) => FlightTag.fromJson(x))),
      wrongTagList: List<WrongTag>.from((json["WrongTagList"] ?? []).map((x) => WrongTag.fromJson(x))),
      binList: List<Bin>.from((json["BinList"] ?? []).map((x) => Bin.fromJson(x))),
      containerList: List<TagContainer>.from((json["ContainerList"] ?? []).map((x) => TagContainer.fromJson(x))),
      transferFlightList: json["TransferFlightList"] == null ? [] : List<TransferFlight>.from(json["TransferFlightList"]!.map((x) => TransferFlight.fromJson(x))),
    );
  }

  factory FlightDetails.merge(FlightDetails newFD, FlightDetails oldFD) {
    // print("*******");
    // print(newFD.containerList.length);
    // print(oldFD.containerList.length);
    // print("*******");
    return FlightDetails(
      flightScheduleId: newFD.flightScheduleId,
      baggageAverageWeight: newFD.baggageAverageWeight,
      weightUnit: newFD.weightUnit,
      tagList: newFD.tagList + newFD.tagList.where((element) => !newFD.tagList.map((e) => e.tagNumber).contains(element.tagNumber)).toList(),
      wrongTagList: newFD.wrongTagList + newFD.wrongTagList.where((element) => !newFD.wrongTagList.map((e) => e.tagNumber).contains(element.tagNumber)).toList(),
      containerList: newFD.containerList + newFD.containerList.where((element) => !newFD.containerList.map((e) => e.typeId).contains(element.typeId)).toList(),
      transferFlightList: newFD.transferFlightList + newFD.transferFlightList.where((element) => !newFD.transferFlightList.map((e) => e.id).contains(element.id)).toList(),
      binList: newFD.binList + newFD.binList.where((element) => !newFD.binList.map((e) => e.id).contains(element.id)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "FlightScheduleID": flightScheduleId,
        "BaggageAverageWeight": baggageAverageWeight,
        "WeightUnit": weightUnit,
        "TagList": List<dynamic>.from(tagList.map((x) => x.toJson())),
        "WrongTagList": List<dynamic>.from(wrongTagList.map((x) => x.toJson())),
        "ContainerList": List<dynamic>.from(containerList.map((x) => x.toJson())),
        "TransferFlightList": List<dynamic>.from(transferFlightList.map((x) => x.toJson())),
        "BinList": List<dynamic>.from(binList.map((x) => x.toJson())),
      };

  List<FlightTag> getPositionTags(Position pos, bool justCurrent, [bool withContainer = false]) {
    switch (pos.id) {
      default:
        {
          if (justCurrent) {
            if (withContainer) {
              return tagList.where((element) => element.tagPositions.first.container != null && element.currentPosition == pos.id).toList();
            } else {
              return tagList.where((element) => element.tagPositions.first.container == null && element.currentPosition == pos.id).toList();
            }
          } else {
            return tagList;
            // if (withContainer) {
            //   return tagList.where((element) => element.tagPositions.any((element) => element.container != null)).toList();
            // } else {
            //   return tagList.where((element) => element.tagPositions.any((element) => element.container == null)).toList();
            // }
          }
        }
    }
  }
}

class FlightTag {
  FlightTag({
    required this.tagId,
    required this.tagNumber,
    required this.currentPosition,
    required this.currentOrder,
    required this.indexInFlight,
    required this.tagPositions,
    this.currentStatus = 0,
    required this.al,
    required this.flightDate,
    required this.flnb,
    required this.actionsHistory,
    required this.flightScheduleId,
    required this.isRush,
    required this.deadline,
    this.exceptionActionsStr = "",
    this.exceptionStatusID = 0,
    this.dcsInfo,
    this.classTypeID = 1,
  });

  int tagId;
  String tagNumber;
  int currentPosition;
  int currentOrder;
  int indexInFlight;
  int currentStatus;
  int exceptionStatusID;
  int classTypeID;
  String flnb;
  int flightScheduleId;
  String flightDate;
  String al;
  String exceptionActionsStr;
  bool isRush;
  int deadline;
  List<TagPosition> tagPositions;
  List<ActionHistory> actionsHistory;
  DcsInfo? dcsInfo;

  factory FlightTag.fromJson(Map<String, dynamic> json) => FlightTag(
        tagId: json["TagID"],
        tagNumber: json["TagNumber"],
        currentPosition: json["CurrentPosition"],
        currentOrder: json["CurrentOrder"],
        exceptionStatusID: json["ExceptionStatusID"] ?? 0,
        indexInFlight: json["IndexInFlight"],
        classTypeID: json["ClassTypeID"] ?? 1,
        flightScheduleId: json["FlightScheduleID"],
        currentStatus: json["CurrentStatus"] ?? 0,
        flnb: json["FLNB"] ?? "",
        flightDate: json["FlightDate"] ?? "",
        al: json["AL"] ?? "",
        isRush: json["IsRush"] ?? false,
        exceptionActionsStr: json["ExcActStr"] ?? "",
        deadline: json["Deadline"] ?? 1000,
        dcsInfo: json["DCSInfo"] == null ? null : DcsInfo.fromJson(json["DCSInfo"]),
        tagPositions: List<TagPosition>.from(json["TagPositions"].map((x) => TagPosition.fromJson(x))),
        actionsHistory: List<ActionHistory>.from((json["ActionsHistory"] ?? []).map((x) => ActionHistory.fromJson(x))),
      );

  // ExceptionStatus get exception => BasicClass.settings.exceptionStatuses.firstWhere((element) => element.id == exceptionStatusID);

  ClassType? get classType => BasicClass.getClassTypeByID(classTypeID);

  bool get isForced => tagPositions.any((element) => element.isForced);

  String get dest => dcsInfo?.dest ?? '';

  Map<String, dynamic> toJson() => {
        "TagID": tagId,
        "TagNumber": tagNumber,
        "CurrentPosition": currentPosition,
        "ExceptionStatusID": exceptionStatusID,
        "CurrentOrder": currentOrder,
        "IndexInFlight": indexInFlight,
        "ExcActStr": exceptionActionsStr,
        "FLNB": flnb,
        "FlightScheduleID": flightScheduleId,
        "FlightDate": flightDate,
        "Deadline": deadline,
        "IsRush": isRush,
        "CurrentStatus": currentStatus,
        "AL": al,
        "ClassTypeID": classTypeID,
        "DCSInfo": dcsInfo?.toJson(),
        "TagPositions": List<dynamic>.from(tagPositions.map((x) => x.toJson())),
        "ActionsHistory": List<dynamic>.from(actionsHistory.map((x) => x.toJson())),
      };

  validateSearch(String searched, Position selectedPosition) {
    return true && ("${dcsInfo?.securityCode} $tagNumber ".toLowerCase().contains(searched.toLowerCase()) || searched == "");
  }

  List<int> get deniedPosIDs => actionsHistory.isEmpty ? [] : (actionsHistory.first.blockedPosition);

  TagStatus get status {
    return BasicClass.getTagStatusByID(currentStatus)!;
  }

  String get numString => tagNumber.toString().padLeft(10, "0").substring(4, 10);

  String get fullString => tagNumber.toString().padLeft(10, "0");

  String get secString {
    // print(BasicClass.settings.classTypeList.map((e) => e.id));
    // print(classTypeID);
    return (dcsInfo?.securityCode ?? "----").toString().padLeft(10, "0").substring(6, 10);
  }

  @override
  String toString() {
    return "Tag ($tagNumber)";
  }

  compare(FlightTag b) {
    if (b.currentStatus == currentStatus) {
      if (b.deadline == deadline) {
        return b.indexInFlight - indexInFlight;
      }
      return deadline - b.deadline;
    }
    return b.currentStatus - currentStatus;
  }

  IconData? get getPosIcon {
    if (tagPositions.isEmpty) return null;
    return BasicClass.getPositionByID(tagPositions.first.positionId)?.getIcon;
  }

  Color? get posColor {
    if (tagPositions.isEmpty) return Colors.transparent;
    return BasicClass.getPositionByID(tagPositions.first.positionId)?.getColor;
  }

  bool get isHot {
    return deadline < 60;
  }
}

class TagPosition {
  TagPosition(
      {required this.sequenceNo,
      required this.indexInPosition,
      required this.indexInBin,
      required this.indexInUld,
      required this.indexInCart,
      required this.positionId,
      required this.airport,
      required this.userId,
      required this.username,
      required this.dateUtc,
      required this.timeUtc,
      required this.positionDesc,
      required this.bin,
      required this.uld,
      required this.uldCode,
      required this.containerCode,
      required this.transferFlight,
      this.transferFlightID,
      this.container,
      this.binID,
      this.isForced = false});

  int sequenceNo;
  int indexInPosition;
  int? indexInBin;
  int? indexInUld;
  int? indexInCart;
  int positionId;
  String airport;
  int userId;
  String username;
  DateTime dateUtc;
  String timeUtc;
  String positionDesc;
  String bin;
  String? containerCode;
  String uld;
  String uldCode;
  bool isForced;
  TagContainer? container;
  int? binID;
  TransferFlight? transferFlight;
  int? transferFlightID;

  TransferFlight? getTransferFlight(List<TransferFlight> tfl) {
    if (transferFlightID == null) return null;
    return tfl.firstWhereOrNull((f) => f.id == transferFlightID);
  }

  factory TagPosition.fromJson(Map<String, dynamic> json) => TagPosition(
        sequenceNo: json["SequenceNo"],
        indexInPosition: json["IndexInPosition"],
        indexInBin: json["IndexInBin"],
        indexInUld: json["IndexInULD"],
        indexInCart: json["IndexInCart"],
        positionId: json["PositionID"],
        airport: json["Airport"],
        userId: json["UserID"],
        username: json["Username"],
        dateUtc: DateTime.parse(json["DateUTC"]),
        timeUtc: json["TimeUTC"],
        positionDesc: json["PositionDesc"],
        bin: json["Bin"],
        uld: json["ULD"],
        uldCode: json["ULDCode"],
        containerCode: json["ContainerCode"] ?? "",
        isForced: json["IsForced"] ?? false,
        transferFlightID: json["TransferFlightID"] ?? null,
        container: json["Container"] == null ? null : TagContainer.fromJson(json["Container"]),
        binID: json["BinID"],
        transferFlight: json["TransferFlight"] == null ? null : TransferFlight.fromJson(json["TransferFlight"]),
      );

  Map<String, dynamic> toJson() => {
        "SequenceNo": sequenceNo,
        "IndexInPosition": indexInPosition,
        "IndexInBin": indexInBin,
        "IndexInULD": indexInUld,
        "IndexInCart": indexInCart,
        "PositionID": positionId,
        "Airport": airport,
        "UserID": userId,
        "Username": username,
        "DateUTC": "${dateUtc.year.toString().padLeft(4, '0')}-${dateUtc.month.toString().padLeft(2, '0')}-${dateUtc.day.toString().padLeft(2, '0')}",
        "TimeUTC": timeUtc,
        "PositionDesc": positionDesc,
        "Bin": bin,
        "ContainerCode": containerCode,
        "ULD": uld,
        "ULDCode": uldCode,
        "IsForced": isForced,
        "Container": container?.toJson(),
        "BinID": binID
      };

  String getTime() {
    DateTime? scanTimeUtc = timeUtc.tryDateTimeUTC;
    DateTime? scanTime = scanTimeUtc?.toLocal();
    return scanTime!.format_HHmmss;
  }
}

class WrongTag {
  WrongTag({
    required this.id,
    required this.positionId,
    required this.createdDate,
    required this.tagNumber,
    required this.indexInFlight,
    required this.indexInPosition,
    required this.type,
    required this.description,
    required this.isForce,
  });

  int id;
  int positionId;
  DateTime createdDate;
  String tagNumber;
  int indexInFlight;
  int indexInPosition;
  int type;
  String description;
  bool isForce;

  factory WrongTag.fromJson(Map<String, dynamic> json) => WrongTag(
        id: json["ID"],
        positionId: json["PositionID"],
        createdDate: DateTime.parse(json["CreatedDate"]),
        tagNumber: json["TagNumber"],
        indexInFlight: json["IndexInFlight"],
        indexInPosition: json["IndexInPosition"],
        type: json["Type"],
        description: json["Description"],
        isForce: json["IsForce"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PositionID": positionId,
        "CreatedDate": createdDate.toIso8601String(),
        "TagNumber": tagNumber,
        "IndexInFlight": indexInFlight,
        "IndexInPosition": indexInPosition,
        "Type": type,
        "Description": description,
        "IsForce": isForce,
      };

  validateSearch(String searched) {
    return searched == "" || "$tagNumber".toLowerCase().contains(searched.toLowerCase());
  }
}

class TagContainer {
  TagContainer({
    required this.id,
    required this.typeId,
    required this.positionID,
    required this.classTypeID,
    required this.title,
    required this.code,
    this.dest = "",
    this.from = "",
    this.barcodePrefix,
    this.isClosed = false,
    required this.ocrPrefix,
  });

  int? id;
  int typeId;
  int positionID;
  int classTypeID;
  String title;
  String code;
  String? barcodePrefix;
  String dest;
  String from;
  List<String> ocrPrefix;
  bool isClosed;

  factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
        id: json["ID"],
        typeId: json["TypeID"] ?? 1,
        classTypeID: json["ClassTypeID"] ?? 1,
        positionID: json["PositionID"] ?? -1,
        title: json["Title"],
        code: json["Code"] ?? "",
        dest: json["Dest"] ?? json["To"] ?? "",
        isClosed: json["IsClosed"] ?? false,
        barcodePrefix: json["BarcodePrefix"],
        ocrPrefix: List<String>.from((json["OCRPrefix"] ?? ["AKE######", "CART######"]).map((x) => x.toString())),
      );

  factory TagContainer.fromQr(String qr) {
    String labelAndTypeID = qr.replaceFirst("ConQR:", "");
    String typeIDStr = labelAndTypeID.split(",").last;
    String label = labelAndTypeID.split(",").first;
    int foundTypeID = int.parse(typeIDStr);
    return TagContainer(
      id: null,
      typeId: foundTypeID,
      classTypeID: 1,
      positionID: -1,
      // title: BasicClass.settings.containers.firstWhere((element) => element.typeId == foundTypeID).title,
      title: '',
      code: label,
      dest: "",
      from: "",
      isClosed: false,
      barcodePrefix: "",
      ocrPrefix: ["AKE######", "CART######"],
    );
  }

  String get getQr => "ConQR:$code,$typeId";

  String get rote => (from.isEmpty || dest.isEmpty) ? "" : "${from}-${dest}";

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TypeID": typeId,
        "ClassTypeID": classTypeID,
        "Title": title,
        "Code": code,
        "Dest": dest,
        "From": from,
        "To": dest,
        "PositionID": positionID,
        "BarcodePrefix": barcodePrefix,
        "OCRPrefix": ocrPrefix,
        "IsClosed": isClosed
      };

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return (other is TagContainer && other.id == id && id != null) || (other is TagContainer && other.typeId == typeId && other.code.toLowerCase() == code.toLowerCase());
    // return (other is TagContainer && other.typeId == typeId && other.code.toLowerCase() == code.toLowerCase());
    // return super == other;
  }

  bool get isLoadable => typeId != 1;

  bool get isException => typeId != 1;

  bool get isCart => typeId == 1;

  ClassType get classType => BasicClass.getClassTypeByID(classTypeID)!;

  List<FlightTag> getTags(FlightDetails fd) {
    return fd.tagList.where((element) => element.tagPositions.first.container == this).toList();
  }
}

class TransferFlight {
  TransferFlight({
    required this.id,
    required this.flnb,
    required this.flightDate,
    required this.al,
    required this.bins,
  });

  final int id;
  final String flnb;
  final DateTime flightDate;
  final String al;
  final List<Bin> bins;

  factory TransferFlight.fromJson(Map<String, dynamic> json) => TransferFlight(
        id: json["ID"],
        flnb: json["FLNB"],
        flightDate: DateTime.parse(json["FlightDate"]),
        al: json["AL"],
        bins: List<Bin>.from((json["Bins"] ?? []).map((x) => Bin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "FLNB": flnb,
        "FlightDate": "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
        "AL": al,
        "Bins": bins.map((e) => e.toJson()).toList()
      };
}

class Bin {
  Bin({
    required this.id,
    required this.bin,
    required this.binNumber,
    required this.containerType,
    required this.isDeleted,
    required this.compartment,
    required this.plannedCount,
    required this.plannedWeight,
  });

  String bin;
  bool isDeleted;
  String binNumber;
  String compartment;
  int containerType;
  int? plannedCount;
  int? plannedWeight;
  int? id;

  factory Bin.fromJson(Map<String, dynamic> json) => Bin(
        id: json["ID"],
        bin: json["Bin"] ?? '',
        isDeleted: json["IsDeleted"] ?? false,
        binNumber: json["BinNumber"] ?? "",
        containerType: json["ContainerType"] ?? 0,
        plannedCount: json["PlannedCount"],
        plannedWeight: json["PlannedWeight"],
        compartment: json["Compartment"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Bin": bin,
        "ID": id,
        "BinNumber": binNumber,
        "IsDeleted": isDeleted,
        "ContainerType": containerType,
        "Compartment": compartment,
        "PlannedCount": plannedCount,
        "PlannedWeight": plannedWeight,
      };

  @override
  String toString() {
    return bin;
  }
}

class ActionHistory {
  ActionHistory({
    required this.id,
    required this.positionId,
    required this.actionId,
    required this.username,
    required this.tagStatus,
    required this.actionDate,
    required this.actionTime,
    required this.blockedPosition,
  });

  int id;
  int positionId;
  int actionId;
  String username;
  int tagStatus;
  DateTime actionDate;
  String actionTime;
  List<int> blockedPosition;

  factory ActionHistory.fromJson(Map<String, dynamic> json) => ActionHistory(
        id: json["ID"],
        positionId: json["PositionID"],
        actionId: json["ActionID"],
        username: json["Username"],
        tagStatus: json["Status"] ?? 0,
        actionDate: DateTime.parse(json["ActionDate"]),
        actionTime: json["ActionTime"],
        blockedPosition: List<int>.from(json["BlockedPositions"].map((x) => x["ID"])),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PositionID": positionId,
        "ActionID": actionId,
        "Username": username,
        "TagStatus": tagStatus,
        "ActionDate": "${actionDate.year.toString().padLeft(4, '0')}-${actionDate.month.toString().padLeft(2, '0')}-${actionDate.day.toString().padLeft(2, '0')}",
        "ActionTime": actionTime,
        "BlockedPositions": List<dynamic>.from(blockedPosition.map((x) => {"ID": x})),
      };
}

class DcsInfo {
  DcsInfo({
    required this.paxId,
    required this.pnr,
    required this.paxName,
    required this.weight,
    required this.count,
    required this.dest,
    required this.securityCode,
  });

  int paxId;
  String pnr;
  String paxName;
  String dest;
  int weight;
  int count;
  int securityCode;

  factory DcsInfo.fromJson(Map<String, dynamic> json) => DcsInfo(
        paxId: json["PaxID"],
        pnr: json["PNR"],
        dest: json["Dest"],
        paxName: json["PaxName"],
        weight: json["Weight"],
        count: json["Count"],
        securityCode: json["SecurityCode"],
      );

  Map<String, dynamic> toJson() => {
        "PaxID": paxId,
        "PNR": pnr,
        "Dest": dest,
        "PaxName": paxName,
        "Weight": weight,
        "Count": count,
        "SecurityCode": securityCode,
      };
}
