// import 'dart:convert';
//
// import 'package:brs_panel/core/enums/flight_type_filter_enum.dart';
//
// class Flight {
//   final int id;
//   final int? aircraftId;
//   final dynamic returnedTagCount;
//   final String color;
//   final String al;
//   final String flightNumber;
//   final DateTime flightDate;
//   final String std;
//   final String sta;
//   final String registration;
//   final String airlineTitle;
//   final String fromCity;
//   final String toCity;
//   final String route;
//   final bool isTest;
//   final int flightType;
//   final String aircraftCode;
//   final int barcodeLength;
//   final int flightCheckinCount;
//   final int flightLoadCount;
//   final int onloadCount;
//   final int flightArrivalCount;
//   final int checkinCount;
//   final int loadCount;
//   final int unloadCount;
//   final int arrivalCount;
//   final List<Position> positions;
//   final List<dynamic> tagActionList;
//   final int bingoSheetRowCount;
//   final int bingoSheetColumnCount;
//   final int totalBagPCs;
//   final int totalBagWeight;
//   final bool isFinalized;
//   final List<BinList> binList;
//
//   Flight({
//     required this.id,
//     required this.aircraftId,
//     required this.returnedTagCount,
//     required this.color,
//     required this.al,
//     required this.flightNumber,
//     required this.flightDate,
//     required this.std,
//     required this.sta,
//     required this.registration,
//     required this.airlineTitle,
//     required this.fromCity,
//     required this.toCity,
//     required this.route,
//     required this.isTest,
//     required this.flightType,
//     required this.aircraftCode,
//     required this.barcodeLength,
//     required this.flightCheckinCount,
//     required this.flightLoadCount,
//     required this.onloadCount,
//     required this.flightArrivalCount,
//     required this.checkinCount,
//     required this.loadCount,
//     required this.unloadCount,
//     required this.arrivalCount,
//     required this.positions,
//     required this.tagActionList,
//     required this.bingoSheetRowCount,
//     required this.bingoSheetColumnCount,
//     required this.totalBagPCs,
//     required this.totalBagWeight,
//     required this.isFinalized,
//     required this.binList,
//   });
//
//   Flight copyWith({
//     int? flightScheduleId,
//     int? aircraftId,
//     dynamic returnedTagCount,
//     String? color,
//     String? al,
//     String? flightNumber,
//     DateTime? flightDate,
//     String? std,
//     String? sta,
//     String? registration,
//     String? airlineTitle,
//     String? fromCity,
//     String? toCity,
//     String? route,
//     bool? isTest,
//     int? flightType,
//     String? aircraftCode,
//     int? barcodeLength,
//     int? flightCheckinCount,
//     int? flightLoadCount,
//     int? onloadCount,
//     int? flightArrivalCount,
//     int? checkinCount,
//     int? loadCount,
//     int? unloadCount,
//     int? arrivalCount,
//     List<Position>? positions,
//     List<dynamic>? tagActionList,
//     int? bingoSheetRowCount,
//     int? bingoSheetColumnCount,
//     int? totalBagPCs,
//     int? totalBagWeight,
//     bool? isFinalized,
//     List<BinList>? binList,
//   }) =>
//       Flight(
//         id: flightScheduleId ?? this.id,
//         aircraftId: aircraftId ?? this.aircraftId,
//         returnedTagCount: returnedTagCount ?? this.returnedTagCount,
//         color: color ?? this.color,
//         al: al ?? this.al,
//         flightNumber: flightNumber ?? this.flightNumber,
//         flightDate: flightDate ?? this.flightDate,
//         std: std ?? this.std,
//         sta: sta ?? this.sta,
//         registration: registration ?? this.registration,
//         airlineTitle: airlineTitle ?? this.airlineTitle,
//         fromCity: fromCity ?? this.fromCity,
//         toCity: toCity ?? this.toCity,
//         route: route ?? this.route,
//         isTest: isTest ?? this.isTest,
//         flightType: flightType ?? this.flightType,
//         aircraftCode: aircraftCode ?? this.aircraftCode,
//         barcodeLength: barcodeLength ?? this.barcodeLength,
//         flightCheckinCount: flightCheckinCount ?? this.flightCheckinCount,
//         flightLoadCount: flightLoadCount ?? this.flightLoadCount,
//         onloadCount: onloadCount ?? this.onloadCount,
//         flightArrivalCount: flightArrivalCount ?? this.flightArrivalCount,
//         checkinCount: checkinCount ?? this.checkinCount,
//         loadCount: loadCount ?? this.loadCount,
//         unloadCount: unloadCount ?? this.unloadCount,
//         arrivalCount: arrivalCount ?? this.arrivalCount,
//         positions: positions ?? this.positions,
//         tagActionList: tagActionList ?? this.tagActionList,
//         bingoSheetRowCount: bingoSheetRowCount ?? this.bingoSheetRowCount,
//         bingoSheetColumnCount: bingoSheetColumnCount ?? this.bingoSheetColumnCount,
//         totalBagPCs: totalBagPCs ?? this.totalBagPCs,
//         totalBagWeight: totalBagWeight ?? this.totalBagWeight,
//         isFinalized: isFinalized ?? this.isFinalized,
//         binList: binList ?? this.binList,
//       );
//
//
//   factory Flight.fromJson(Map<String, dynamic> json) => Flight(
//     id: json["FlightScheduleID"],
//     aircraftId: json["AircraftID"],
//     returnedTagCount: json["ReturnedTagCount"],
//     color: json["Color"],
//     al: json["AL"],
//     flightNumber: json["FlightNumber"],
//     flightDate: DateTime.parse(json["FlightDate"]),
//     std: json["STD"],
//     sta: json["STA"],
//     registration: json["Registration"],
//     airlineTitle: json["AirlineTitle"],
//     fromCity: json["FromCity"],
//     toCity: json["ToCity"],
//     route: json["Route"],
//     isTest: json["IsTest"],
//     flightType: json["FlightType"],
//     aircraftCode: json["AircraftCode"],
//     barcodeLength: json["BarcodeLength"],
//     flightCheckinCount: json["Checkin_Count"],
//     flightLoadCount: json["Load_Count"],
//     onloadCount: json["Onload_Count"],
//     flightArrivalCount: json["Arrival_Count"],
//     checkinCount: json["CheckinCount"],
//     loadCount: json["LoadCount"],
//     unloadCount: json["UnloadCount"],
//     arrivalCount: json["ArrivalCount"],
//     positions: List<Position>.from(json["Positions"].map((x) => Position.fromJson(x))),
//     tagActionList: List<dynamic>.from(json["TagActionList"].map((x) => x)),
//     bingoSheetRowCount: json["BingoSheetRowCount"],
//     bingoSheetColumnCount: json["BingoSheetColumnCount"],
//     totalBagPCs: json["TotalBagPCs"],
//     totalBagWeight: json["TotalBagWeight"],
//     isFinalized: json["IsFinalized"],
//     // binList: List<BinList>.from(json["BinList"].map((x) => BinList.fromJson(x))),
//     binList: []
//   );
//
//   Map<String, dynamic> toJson() => {
//     "FlightScheduleID": id,
//     "AircraftID": aircraftId,
//     "ReturnedTagCount": returnedTagCount,
//     "Color": color,
//     "AL": al,
//     "FlightNumber": flightNumber,
//     "FlightDate": "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
//     "STD": std,
//     "STA": sta,
//     "Registration": registration,
//     "AirlineTitle": airlineTitle,
//     "FromCity": fromCity,
//     "ToCity": toCity,
//     "Route": route,
//     "IsTest": isTest,
//     "FlightType": flightType,
//     "AircraftCode": aircraftCode,
//     "BarcodeLength": barcodeLength,
//     "Checkin_Count": flightCheckinCount,
//     "Load_Count": flightLoadCount,
//     "Onload_Count": onloadCount,
//     "Arrival_Count": flightArrivalCount,
//     "CheckinCount": checkinCount,
//     "LoadCount": loadCount,
//     "UnloadCount": unloadCount,
//     "ArrivalCount": arrivalCount,
//     "Positions": List<dynamic>.from(positions.map((x) => x.toJson())),
//     "TagActionList": List<dynamic>.from(tagActionList.map((x) => x)),
//     "BingoSheetRowCount": bingoSheetRowCount,
//     "BingoSheetColumnCount": bingoSheetColumnCount,
//     "TotalBagPCs": totalBagPCs,
//     "TotalBagWeight": totalBagWeight,
//     "IsFinalized": isFinalized,
//     "BinList": List<dynamic>.from(binList.map((x) => x.toJson())),
//   };
//
//   bool validateType(FlightTypeFilter typeFilter) {
//     return flightType == typeFilter.index;
//   }
//
//   bool validateSearch(String s) {
//     return s.isEmpty || "$al$flightNumber".toLowerCase().contains(s.toLowerCase());
//   }
//
//   @override
//   String toString() => flightNumber;
// }
//
// class BinList {
//   final String bin;
//   final int containerType;
//   final String compartment;
//   final int id;
//   final int maxCapacity;
//
//   BinList({
//     required this.bin,
//     required this.containerType,
//     required this.compartment,
//     required this.id,
//     required this.maxCapacity,
//   });
//
//   BinList copyWith({
//     String? bin,
//     int? containerType,
//     String? compartment,
//     int? id,
//     int? maxCapacity,
//   }) =>
//       BinList(
//         bin: bin ?? this.bin,
//         containerType: containerType ?? this.containerType,
//         compartment: compartment ?? this.compartment,
//         id: id ?? this.id,
//         maxCapacity: maxCapacity ?? this.maxCapacity,
//       );
//
//   factory BinList.fromRawJson(String str) => BinList.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory BinList.fromJson(Map<String, dynamic> json) => BinList(
//     bin: json["Bin"],
//     containerType: json["ContainerType"],
//     compartment: json["Compartment"],
//     id: json["ID"],
//     maxCapacity: json["MaxCapacity"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Bin": bin,
//     "ContainerType": containerType,
//     "Compartment": compartment,
//     "ID": id,
//     "MaxCapacity": maxCapacity,
//   };
// }
//
// class Position {
//   final int id;
//   final String title;
//   final int tagCount;
//   final int excTagCount;
//   final bool binRequired;
//   final int? prevPos;
//   final int? nextPos;
//   final bool containerRequired;
//   final bool transferFlightRequired;
//   final int order;
//   final bool? containerAction;
//   final bool showEmptyContainers;
//   final List<Action> actions;
//
//   Position({
//     required this.id,
//
//     required this.title,
//     required this.tagCount,
//     required this.excTagCount,
//     required this.binRequired,
//     required this.prevPos,
//     required this.nextPos,
//     required this.containerRequired,
//     required this.transferFlightRequired,
//     required this.order,
//     required this.containerAction,
//     required this.showEmptyContainers,
//     required this.actions,
//   });
//
//   Position copyWith({
//     int? id,
//     String? title,
//     int? tagCount,
//     int? excTagCount,
//     bool? binRequired,
//     int? prevPos,
//     dynamic nextPos,
//     bool? containerRequired,
//     bool? transferFlightRequired,
//     int? order,
//     bool? containerAction,
//     bool? showEmptyContainers,
//     List<Action>? actions,
//   }) =>
//       Position(
//         id: id ?? this.id,
//         title: title ?? this.title,
//         tagCount: tagCount ?? this.tagCount,
//         excTagCount: excTagCount ?? this.excTagCount,
//         binRequired: binRequired ?? this.binRequired,
//         prevPos: prevPos ?? this.prevPos,
//         nextPos: nextPos ?? this.nextPos,
//         containerRequired: containerRequired ?? this.containerRequired,
//         transferFlightRequired: transferFlightRequired ?? this.transferFlightRequired,
//         order: order ?? this.order,
//         containerAction: containerAction ?? this.containerAction,
//         showEmptyContainers: showEmptyContainers ?? this.showEmptyContainers,
//         actions: actions ?? this.actions,
//       );
//
//   factory Position.fromRawJson(String str) => Position.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Position.fromJson(Map<String, dynamic> json) => Position(
//     id: json["ID"],
//     title: json["Title"],
//     tagCount: json["TagCount"],
//     excTagCount: json["ExcTagCount"],
//     binRequired: json["BinRequired"],
//     prevPos: json["PrevPos"],
//     nextPos: json["NextPos"],
//     containerRequired: json["ContainerRequired"],
//     transferFlightRequired: json["TransferFlightRequired"],
//     order: json["Order"],
//     containerAction: json["ContainerAction"],
//     showEmptyContainers: json["ShowEmptyContainers"],
//     actions: List<Action>.from(json["Actions"].map((x) => Action.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "ID": id,
//     "Title": title,
//     "TagCount": tagCount,
//     "ExcTagCount": excTagCount,
//     "BinRequired": binRequired,
//     "PrevPos": prevPos,
//     "NextPos": nextPos,
//     "ContainerRequired": containerRequired,
//     "TransferFlightRequired": transferFlightRequired,
//     "Order": order,
//     "ContainerAction": containerAction,
//     "ShowEmptyContainers": showEmptyContainers,
//     "Actions": List<dynamic>.from(actions.map((x) => x.toJson())),
//   };
// }
//
// class Action {
//   final int id;
//
//   Action({
//     required this.id,
//   });
//
//   Action copyWith({
//     int? id,
//   }) =>
//       Action(
//         id: id ?? this.id,
//       );
//
//   factory Action.fromRawJson(String str) => Action.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Action.fromJson(Map<String, dynamic> json) => Action(
//     id: json["ID"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "ID": id,
//   };
// }

// To parse this JSON data, do
//
//     final flight = flightFromJson(jsonString);


import 'package:brs_panel/core/util/basic_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums/flight_type_filter_enum.dart';
import 'airport_class.dart';
import 'login_user_class.dart';

@immutable
class Flight {
  final int id;
  final int? aircraftId;
  final int? returnedTagCount;
  final String color;
  final String al;
  final String flightNumber;
  final DateTime flightDate;
  final String std;
  final String sta;
  final String from;
  final String to;
  final String route;
  final String? destList;
  final bool isTest;
  final int flightType;
  final int totalBagPCs;
  final int totalBagWeight;
  final bool isFinalized;
  final List<PositionData> positions;

  const Flight({
    required this.id,
    required this.aircraftId,
    required this.returnedTagCount,
    required this.color,
    required this.al,
    required this.flightNumber,
    required this.flightDate,
    required this.std,
    required this.sta,
    required this.from,
    required this.to,
    required this.destList,
    required this.route,
    required this.isTest,
    required this.flightType,
    required this.totalBagPCs,
    required this.totalBagWeight,
    required this.isFinalized,
    required this.positions,
  });

  Aircraft? get getAircraft => BasicClass.getAircraftByID(aircraftId);

  bool get isArrival => flightType==1;

  List<int> get validPositions => isArrival?[4,5,6]:[1,2,3];
  List<int> get validAssignContainerPositions => isArrival?[4,5]:[2];

  Flight copyWith({
    int? id,
    int? aircraftId,
    int? returnedTagCount,
    String? color,
    String? al,
    String? flightNumber,
    DateTime? flightDate,
    String? std,
    String? sta,
    String? from,
    String? to,
    String? destList,
    String? route,
    bool? isTest,
    int? flightType,
    int? totalBagPCs,
    int? totalBagWeight,
    bool? isFinalized,
    List<PositionData>? positions,
  }) =>
      Flight(
        id: id ?? this.id,
        aircraftId: aircraftId ?? this.aircraftId,
        returnedTagCount: returnedTagCount ?? this.returnedTagCount,
        color: color ?? this.color,
        al: al ?? this.al,
        flightNumber: flightNumber ?? this.flightNumber,
        flightDate: flightDate ?? this.flightDate,
        std: std ?? this.std,
        sta: sta ?? this.sta,
        from: from ?? this.from,
        to: to ?? this.to,
        destList: destList ?? this.destList,
        route: route ?? this.route,
        isTest: isTest ?? this.isTest,
        flightType: flightType ?? this.flightType,
        totalBagPCs: totalBagPCs ?? this.totalBagPCs,
        totalBagWeight: totalBagWeight ?? this.totalBagWeight,
        isFinalized: isFinalized ?? this.isFinalized,
        positions: positions ?? this.positions,
      );

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
    id: json["FlightScheduleID"],
    aircraftId: json["AircraftID"],
    returnedTagCount: json["ReturnedTagCount"],
    color: json["Color"],
    al: json["AL"],
    flightNumber: json["FlightNumber"],
    flightDate: DateTime.parse(json["FlightDate"]),
    std: json["STD"],
    sta: json["STA"],
    from: json["FromCity"],
    to: json["ToCity"],
    destList: json["DestList"],
    route: json["Route"],
    isTest: json["IsTest"],
    flightType: json["FlightType"]??1,
    totalBagPCs: json["TotalBagPCs"],
    totalBagWeight: json["TotalBagWeight"],
    isFinalized: json["IsFinalized"],
    positions: List<PositionData>.from((json["Positions"]??[]).map((x) => PositionData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "FlightScheduleID": id,

    "AircraftID": aircraftId,
    "ReturnedTagCount": returnedTagCount,
    "Color": color,
    "AL": al,
    "FlightNumber": flightNumber,
    "FlightDate": "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
    "STD": std,
    "STA": sta,
    "FromCity": from,
    "ToCity": to,
    "DestList": destList,
    "Route": route,
    "IsTest": isTest,
    "FlightType": flightType,
    "TotalBagPCs": totalBagPCs,
    "TotalBagWeight": totalBagWeight,
    "IsFinalized": isFinalized,
    "Positions": List<dynamic>.from(positions.map((x) => x.toJson())),
  };

  bool validateType(FlightTypeFilter typeFilter) {
    return flightType == typeFilter.index;
  }

  bool validateAirline(String? a) {
    return a==null || al == a;
  }

  bool validateAirport(Airport? a) {
    return a==null || from == a.code;
  }

  bool validateSearch(String s) {
    return s.isEmpty || "$al$flightNumber".toLowerCase().contains(s.toLowerCase());
  }

  List<String> get destinations => (destList??to).split(",");

  @override
  String toString() => flightNumber;
}

class PositionData {
  final int id;
  final int tagCount;
  final int order;
  final int excTagCount;
  final List<PositionSection> sections;

  PositionData({
    required this.id,
    required this.tagCount,
    required this.order,
    required this.excTagCount,
    required this.sections,
  });

  PositionData copyWith({
    int? id,
    int? tagCount,
    int? order,
    int? excTagCount,
    List<PositionSection>? sections,
  }) =>
      PositionData(
        id: id ?? this.id,
        tagCount: tagCount ?? this.tagCount,
        order: order ?? this.order,
        excTagCount: excTagCount ?? this.excTagCount,
        sections: sections ?? this.sections,
      );

  factory PositionData.fromJson(Map<String, dynamic> json) => PositionData(
    id: json["ID"],
    tagCount: json["TagCount"],
    order: json["Order"],
    excTagCount: json["ExcTagCount"]??1,
    sections: List<PositionSection>.from((json["Sections"]??[]).map((x) => PositionSection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "TagCount": tagCount,
    "Order": order,
    "ExcTagCount": excTagCount,
    "Sections": List<dynamic>.from(sections.map((x) => x.toJson())),
  };

  Color get color => Colors.green;
  String get value => "$tagCount";
}
