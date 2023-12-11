import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import 'package:brs_panel/core/constants/assest.dart';
import 'package:flutter/material.dart';

import '../constants/abomis_pack_icons.dart';
import '../util/basic_class.dart';
import 'tag_container_class.dart';
import 'login_user_class.dart';

@immutable
class FlightDetails {
  const FlightDetails({
    required this.flightScheduleId,
    required this.tagList,
    required this.wrongTagList,
    required this.containerList,
    required this.baggageAverageWeight,
    required this.weightUnit,
    required this.transferFlightList,
    required this.binList,
  });

  final int flightScheduleId;
  final String weightUnit;
  final int baggageAverageWeight;
  final List<FlightTag> tagList;
  final List<WrongTag> wrongTagList;
  final List<TagContainer> containerList;
  final List<TransferFlight> transferFlightList;
  final List<Bin> binList;

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

@immutable
class FlightTag {
  const FlightTag({
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
    required this.sectionID,
    required this.typeID,
    this.exceptionActionsStr = "",
    this.exceptionStatusID = 0,
    this.dcsInfo,
    this.classTypeID = 1,
    this.tagSsrs = const [],
    this.outboundLegs = const [],
    this.inboundLeg,
    this.hasChanged = false,
    this.isGateTag = false,
  });

  final int tagId;
  final int sectionID;
  final String tagNumber;
  final int currentPosition;
  final int currentOrder;
  final int indexInFlight;
  final int currentStatus;
  final int exceptionStatusID;
  final int classTypeID;
  final String flnb;
  final int flightScheduleId;
  final String flightDate;
  final String al;
  final String exceptionActionsStr;
  final bool isRush;
  final int deadline;
  final List<TagPosition> tagPositions;
  final List<ActionHistory> actionsHistory;
  final DcsInfo? dcsInfo;
  final TagLeg? inboundLeg;
  final List<TagLeg> outboundLegs;
  final List<TagSSR> tagSsrs;
  final bool isGateTag;
  final bool hasChanged;
  final int typeID;

  factory FlightTag.fromJson(Map<String, dynamic> json) => FlightTag(
        tagId: json["TagID"],
        sectionID: json["SectionID"],
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
        typeID: json["TypeID"] ?? 1,
        dcsInfo: json["DCSInfo"] == null ? null : DcsInfo.fromJson(json["DCSInfo"]),
        tagPositions: List<TagPosition>.from(json["TagPositions"].map((x) => TagPosition.fromJson(x))),
        actionsHistory: List<ActionHistory>.from((json["ActionsHistory"] ?? []).map((x) => ActionHistory.fromJson(x))),
        outboundLegs: List<TagLeg>.from(json["OutboundList"].map((x) => TagLeg.fromJson(x))),
        tagSsrs: List<TagSSR>.from(json["SSRList"].map((x) => TagSSR.fromJson(x))),
        inboundLeg: json["InboundItem"] == null ? null : TagLeg.fromJson(json["InboundItem"]),
      );

  // ExceptionStatus get exception => BasicClass.settings.exceptionStatuses.firstWhere((element) => element.id == exceptionStatusID);

  ClassType? get classType => BasicClass.getClassTypeByID(classTypeID);

  bool get isForced => tagPositions.any((element) => element.isForced);

  String get dest => dcsInfo?.dest ?? '';

  int? get getContainerID => tagPositions.first.container?.id;

  Widget get weight => dcsInfo == null
      ? SizedBox()
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${dcsInfo!.weight}'),
            Text(
              "KG",
              style: TextStyle(fontSize: 8),
            )
          ],
        );

  int? get containerID => tagPositions.first.container?.id;

  int? get binID => tagPositions.first.binID;

  bool get isFree => binID == null && containerID == null;

  TagStatus get getStatus => BasicClass.systemSetting.statusList.firstWhere((element) => element.id == currentStatus);

  Widget get getStatusWidget => Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: getStatus.getColor.withOpacity(0.3)),
        child: Center(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (getStatus.getIcon != null) Icon(getStatus.getIcon, color: getStatus.getColor, size: 12),
              RichText(
                  text: TextSpan(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), children: [
                TextSpan(
                  // text: "${getType.label}",
                  text: getStatus.title,
                  style: TextStyle(color: getStatus.getColor),
                ),
              ])),
            ],
          ),
        ),
      );

  Widget? get getInboundWidget => inboundLeg == null
      ? null
      : Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.green.withOpacity(0.3)),
          child: Center(
            child: Row(
              children: [
                if (getStatus.getIcon != null) const Icon(Icons.flight_land, color: Colors.green, size: 12),
                RichText(
                    text: const TextSpan(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), children: [
                  TextSpan(
                    text: "Inbound",
                    style: TextStyle(color: Colors.green),
                  ),
                ])),
              ],
            ),
          ),
        );

  Widget? get getOutboundWidget => outboundLegs.isEmpty
      ? null
      : Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.blue.withOpacity(0.3)),
          child: Center(
            child: Row(
              children: [
                if (getStatus.getIcon != null) const Icon(Icons.flight_takeoff, color: Colors.blue, size: 12),
                RichText(
                    text: const TextSpan(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), children: [
                  TextSpan(
                    text: "Onward",
                    style: TextStyle(color: Colors.blue),
                  ),
                ])),
              ],
            ),
          ),
        );

  Widget? getTagSsrsWidget(String text) => Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.green.withOpacity(0.3)),
        child: Center(
          child: Row(
            children: [
              RichText(
                  text: TextSpan(style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), children: [
                TextSpan(
                  text: text,
                  style: const TextStyle(color: Colors.green),
                ),
              ])),
            ],
          ),
        ),
      );

  TagType? get getType {
    // print("looking for ${typeID} in ${BasicClass.settings.systemSettings.tagTypeList.map((e) => e.id).toList()}");
    return typeID == null ? BasicClass.systemSetting.tagTypeList.first : BasicClass.systemSetting.tagTypeList.firstWhereOrNull((element) => element.id == typeID);
  }

  Widget get getTypeWidget => Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: getType?.getColor.withOpacity(1) ?? Colors.transparent),
        child: RichText(
            text: TextSpan(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), children: [
          TextSpan(
            // text: "${getType.label}",
            text: "${getType?.label ?? ''}",
            style: TextStyle(color: getType?.getTextColor),
          ),
        ])),
      );

  Widget get getGateWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.green.withOpacity(0.3) ?? Colors.transparent),
        child: Center(
          child: Row(
            children: [
              if (getStatus.getIcon != null) const Icon(AbomisIconPack.denyLoad, color: Colors.green, size: 0),
              RichText(
                  text: const TextSpan(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), children: [
                TextSpan(
                  // text: "${getType.label}",
                  text: "GATE",
                  style: TextStyle(color: Colors.green),
                ),
              ])),
            ],
          ),
        ),
      );

  TagStatus? get exception => BasicClass.getTagStatusById(currentStatus);

  String get getAddress => BasicClass.getAirportSectionByID(sectionID)?.label ?? tagPositions.first.container?.code ?? (tagPositions.first.bin.isEmpty ? getSection.label : tagPositions.first.bin);

  AirportPositionSection get getSection {
    try {
      return BasicClass.getAllAirportSections().firstWhere((element) => element.position == currentPosition && sectionID == element.id,
          orElse: () => BasicClass.getAllAirportSections().firstWhere((element) => element.position == currentPosition, orElse: () => BasicClass.getAllAirportSections().first));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "TagID": tagId,
        "SectionID": sectionID,
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
        "OutboundList": List<dynamic>.from(outboundLegs.map((x) => x.toJson())),
        "SSRList": List<dynamic>.from(tagSsrs.map((x) => x.toJson())),
        "InboundItem": inboundLeg?.toJson()
      };

  bool validateSearch(String searched, Position? selectedPosition) {
    return (selectedPosition == null || currentPosition == selectedPosition.id) &&
        ("${dcsInfo?.securityCode ?? ''} ${dcsInfo?.paxName ?? ''} $tagNumber ".toLowerCase().contains(searched.toLowerCase()) || searched == "");
  }

  List<int> get deniedPosIDs => actionsHistory.isEmpty ? [] : (actionsHistory.first.blockedPosition);

  TagStatus get status {
    return BasicClass.getTagStatusByID(currentStatus)!;
  }

  String get numString => tagNumber.toString().padLeft(10, "0").substring(0, 10);

  String get fullString => tagNumber.toString().padLeft(10, "0");

  String get secString {
    // print(BasicClass.settings.classTypeList.map((e) => e.id));
    // print(classTypeID);
    return (dcsInfo?.securityCode ?? "----").toString().padLeft(10, "0").substring(6, 10);
  }

  IconData? get posIcon {
    if (tagPositions.isEmpty) return null;
    return BasicClass.getPositionById(tagPositions.first.positionId)?.getIcon;
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

class TagSSR {
  final String name;

  TagSSR({
    required this.name,
  });

  TagSSR copyWith({
    String? name,
  }) =>
      TagSSR(
        name: name ?? this.name,
      );

  factory TagSSR.fromJson(Map<String, dynamic> json) => TagSSR(
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
      };
}

class TagLeg {
  final String al;
  final String flnb;
  final DateTime flightDate;
  final String city;
  final String type;

  TagLeg({
    required this.al,
    required this.flnb,
    required this.flightDate,
    required this.city,
    required this.type,
  });

  TagLeg copyWith({
    String? al,
    String? flnb,
    DateTime? flightDate,
    String? city,
    String? type,
  }) =>
      TagLeg(
        al: al ?? this.al,
        flnb: flnb ?? this.flnb,
        flightDate: flightDate ?? this.flightDate,
        city: city ?? this.city,
        type: type ?? this.type,
      );

  factory TagLeg.fromJson(Map<String, dynamic> json) => TagLeg(
        al: json["AL"],
        flnb: json["FLNB"],
        flightDate: DateTime.parse(json["FlightDate"]),
        city: json["City"],
        type: json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "AL": al,
        "FLNB": flnb,
        "FlightDate": "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
        "City": city,
        "Type": type,
      };

  @override
  bool operator ==(Object other) {
    return other is TagLeg && other.flnb == flnb && other.al == al;
  }
}

@immutable
class TagPosition {
  const TagPosition(
      {required this.sequenceNo,
      required this.indexInPosition,
      required this.sectionID,
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

  final int sequenceNo;
  final int sectionID;

  final int indexInPosition;
  final int? indexInBin;
  final int? indexInUld;
  final int? indexInCart;
  final int positionId;
  final String airport;
  final int userId;
  final String username;
  final DateTime dateUtc;
  final String timeUtc;
  final String positionDesc;
  final String bin;
  final String? containerCode;
  final String uld;
  final String uldCode;
  final bool isForced;
  final TagContainer? container;
  final int? binID;
  final TransferFlight? transferFlight;
  final int? transferFlightID;

  TransferFlight? getTransferFlight(List<TransferFlight> tfl) {
    if (transferFlightID == null) return null;
    return tfl.firstWhereOrNull((f) => f.id == transferFlightID);
  }

  factory TagPosition.fromJson(Map<String, dynamic> json) => TagPosition(
        sequenceNo: json["SequenceNo"],
        sectionID: json["SectionID"],
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
        transferFlightID: json["TransferFlightID"],
        container: json["Container"] == null ? null : TagContainer.fromJson(json["Container"]),
        binID: json["BinID"],
        transferFlight: json["TransferFlight"] == null ? null : TransferFlight.fromJson(json["TransferFlight"]),
      );

  Map<String, dynamic> toJson() => {
        "SequenceNo": sequenceNo,
        "IndexInPosition": indexInPosition,
        "SectionID": sectionID,
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

@immutable
class WrongTag {
  const WrongTag({
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

  final int id;
  final int positionId;
  final DateTime createdDate;
  final String tagNumber;
  final int indexInFlight;
  final int indexInPosition;
  final int type;
  final String description;
  final bool isForce;

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

// @immutable
// class TagContainer {
//   const TagContainer({
//     required this.id,
//     this.flightID,
//     required this.typeId,
//     required this.positionID,
//     required this.classTypeID,
//     required this.title,
//     required this.code,
//     this.dest = "",
//     this.from = "",
//     this.barcodePrefix,
//     this.isClosed = false,
//     required this.ocrPrefix,
//   });
//
//   final int? id;
//   final int? flightID;
//   final int typeId;
//   final int positionID;
//   final int classTypeID;
//   final String title;
//   final String code;
//   final String? barcodePrefix;
//   final String dest;
//   final String from;
//   final List<String> ocrPrefix;
//   final bool isClosed;
//
//   factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
//         id: json["ID"],
//         flightID: json["FlightID"]??json["FlightScheduleID"],
//         typeId: json["TypeID"] ?? 1,
//         classTypeID: json["ClassTypeID"] ?? 1,
//         positionID: json["PositionID"] ?? -1,
//         title: json["Title"]??"",
//         code: json["Code"] ?? "",
//         dest: json["Dest"] ?? json["To"] ?? "",
//         isClosed: json["IsClosed"] ?? false,
//         barcodePrefix: json["BarcodePrefix"],
//         ocrPrefix: List<String>.from((json["OCRPrefix"] ?? ["AKE######", "CART######"]).map((x) => x.toString())),
//       );
//
//   factory TagContainer.fromQr(String qr) {
//     String labelAndTypeID = qr.replaceFirst("ConQR:", "");
//     String typeIDStr = labelAndTypeID.split(",").last;
//     String label = labelAndTypeID.split(",").first;
//     int foundTypeID = int.parse(typeIDStr);
//     return TagContainer(
//       id: null,
//       typeId: foundTypeID,
//       flightID: null,
//       classTypeID: 1,
//       positionID: -1,
//       // title: BasicClass.settings.containers.firstWhere((element) => element.typeId == foundTypeID).title,
//       title: '',
//       code: label,
//       dest: "",
//       from: "",
//       isClosed: false,
//       barcodePrefix: "",
//       ocrPrefix: ["AKE######", "CART######"],
//     );
//   }
//
//   factory TagContainer.bulk(int? posId) {
//     return TagContainer(
//       id: -100,
//       typeId: 1,
//       flightID: null,
//       classTypeID: 1,
//       positionID: posId??-1,
//       title: '',
//       code: "",
//       dest: "",
//       from: "",
//       isClosed: false,
//       barcodePrefix: "",
//       ocrPrefix: ["AKE######", "CART######"],
//     );
//   }
//
//   bool get isBulk => id==-100;
//
//   String get getQr => "ConQR:$code,$typeId";
//
//   String get rote => (from.isEmpty || dest.isEmpty) ? "" : "${from}-${dest}";
//
//   String get type => typeId ==1?'ULD':"Cart";
//
//   String get barcode => barcodePrefix??'';
//
//   Map<String, dynamic> toJson() => {
//         "ID": id,
//         "FlightID":flightID,
//         "TypeID": typeId,
//         "ClassTypeID": classTypeID,
//         "Title": title,
//         "Code": code,
//         "Dest": dest,
//         "From": from,
//         "To": dest,
//         "PositionID": positionID,
//         "BarcodePrefix": barcodePrefix,
//         "OCRPrefix": ocrPrefix,
//         "IsClosed": isClosed
//       };
//
//   @override
//   bool operator ==(Object other) {
//     // TODO: implement ==
//     return (other is TagContainer && other.id == id && id != null) || (other is TagContainer && other.typeId == typeId && other.code.toLowerCase() == code.toLowerCase());
//     // return (other is TagContainer && other.typeId == typeId && other.code.toLowerCase() == code.toLowerCase());
//     // return super == other;
//   }
//
//   bool get isLoadable => typeId != 1;
//
//   bool get isException => typeId != 1;
//
//   bool get isCart => typeId == 1;
//
//   ClassType get classType => BasicClass.getClassTypeByID(classTypeID)!;
//
//   Widget get getImg => isBulk?SizedBox(): Image.asset(isCart? AssetImages.cart:AssetImages.uld,width: 30,height: 30,);
//
//   List<FlightTag> getTags(FlightDetails fd) {
//     return fd.tagList.where((element) => element.tagPositions.first.container == this).toList();
//   }
//
//   bool validateSearch(String s) {
//     return s.isEmpty || "$code".toLowerCase().contains(s.toLowerCase());
//   }
// }

@immutable
class TransferFlight {
  const TransferFlight({
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

@immutable
class Bin {
  const Bin({
    required this.id,
    required this.sectionID,
    required this.bin,
    required this.binNumber,
    required this.containerType,
    required this.isDeleted,
    required this.compartment,
    required this.plannedCount,
    required this.plannedWeight,
  });

  final String bin;
  final int? sectionID;
  final bool isDeleted;
  final String binNumber;
  final String compartment;
  final int containerType;
  final int? plannedCount;
  final int? plannedWeight;
  final int? id;

  Bin copyWith({String? bin, int? sectionID, bool? isDeleted, String? binNumber, String? compartment, int? containerType, int? plannedCount, int? plannedWeight, int? id}) => Bin(
        bin: bin ?? this.bin,
        sectionID: sectionID ?? this.sectionID,
        isDeleted: isDeleted ?? this.isDeleted,
        binNumber: binNumber ?? this.binNumber,
        compartment: compartment ?? this.compartment,
        containerType: containerType ?? this.containerType,
        plannedCount: plannedCount ?? this.plannedCount,
        plannedWeight: plannedWeight ?? this.plannedWeight,
        id: id ?? this.id,
      );

  factory Bin.fromJson(Map<String, dynamic> json) => Bin(
        id: json["ID"],
        sectionID: json["SectionID"],
        bin: json["Bin"] ?? '',
        isDeleted: json["IsDeleted"] ?? false,
        binNumber: json["BinNumber"] ?? "",
        containerType: json["ContainerType"] ?? 0,
        plannedCount: json["PlannedCount"],
        plannedWeight: json["PlannedWeight"],
        compartment: json["Compartment"] ?? "",
      );

  factory Bin.empty() {
    return Bin(bin: '', containerType: 1, binNumber: '', id: null, isDeleted: false, compartment: '', plannedCount: null, plannedWeight: null, sectionID: null);
  }

  Map<String, dynamic> toJson() => {
        "Bin": bin,
        "ID": id,
        "SectionID": sectionID,
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

@immutable
class ActionHistory {
  const ActionHistory({
    required this.id,
    required this.positionId,
    required this.actionId,
    required this.username,
    required this.tagStatus,
    required this.actionDate,
    required this.actionTime,
    required this.blockedPosition,
  });

  final int id;
  final int positionId;
  final int actionId;
  final String username;
  final int tagStatus;
  final DateTime actionDate;
  final String actionTime;
  final List<int> blockedPosition;

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

@immutable
class DcsInfo {
  const DcsInfo({
    required this.paxId,
    required this.pnr,
    required this.paxName,
    required this.weight,
    required this.count,
    required this.dest,
    required this.securityCode,
  });

  final int paxId;
  final String pnr;
  final String paxName;
  final String dest;
  final int weight;
  final int count;
  final int securityCode;

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
