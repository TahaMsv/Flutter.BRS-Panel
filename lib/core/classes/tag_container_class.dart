// import 'package:brs_panel/core/classes/login_user_class.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../constants/assest.dart';
// import '../util/basic_class.dart';
// import 'flight_details_class.dart';
//
// @immutable
// class TagContainer {
//   final int? id;
//   final int? sectionID;
//   final int? flightId;
//   final int typeId;
//   final String code;
//   final int? positionId;
//   final String bin;
//   final String title;
//   final String? closedTime;
//   final int? classTypeId;
//   final String? destination;
//   final String? classList;
//   final String? destList;
//   final String? from;
//   final String? to;
//   final int? tagCount;
//
//   const TagContainer({
//     required this.id,
//     required this.sectionID,
//     this.flightId,
//     this.typeId=1,
//     required this.code,
//     required this.positionId,
//     this.bin ='',
//     required this.title,
//      this.closedTime,
//      this.classTypeId,
//      this.destination,
//      this.classList,
//      this.destList,
//      this.from,
//      this.to,
//     this.tagCount,
//   });
//
//   Position? get getPosition => BasicClass.getPositionByID(positionId);
//   List<ClassType>? get getClassTypes => (classList??'').split(",").map((e) => BasicClass.getClassTypeByCode(e)!).toList();
//
//   TagContainer copyWith({
//     int? id,
//     int? sectionID,
//     int? flightId,
//     int? typeId,
//     String? code,
//     int? positionId,
//     String? bin,
//     String? title,
//     String? closedTime,
//     int? classTypeId,
//     String? destination,
//     String? classList,
//     String? destList,
//     String? from,
//     String? to,
//     int? tagCount,
//   }) =>
//       TagContainer(
//         id: id ?? this.id,
//         sectionID: sectionID ?? this.sectionID,
//         flightId: flightId ?? this.flightId,
//         typeId: typeId ?? this.typeId,
//         code: code ?? this.code,
//         positionId: positionId ?? this.positionId,
//         bin: bin ?? this.bin,
//         title: title ?? this.title,
//         closedTime: closedTime ?? this.closedTime,
//         classTypeId: classTypeId ?? this.classTypeId,
//         destination: destination ?? this.destination,
//         classList: classList ?? this.classList,
//         destList: destList ?? this.destList,
//         from: from ?? this.from,
//         to: to ?? this.to,
//         tagCount: tagCount ?? this.tagCount,
//       );
//
//   factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
//     id: json["ID"],
//     sectionID: json["SectionID"],
//     flightId: json["FlightID"],
//     typeId: json["TypeID"],
//     code: json["Code"]??'',
//     positionId: json["PositionID"],
//     bin: json["Bin"]??'',
//     title: json["Title"],
//     closedTime: json["ClosedTime"],
//     classTypeId: json["ClassTypeID"],
//     destination: json["Destination"],
//     classList: json["ClassList"],
//     destList: json["DestList"],
//     from: json["FROM"],
//     to: json["To"],
//     tagCount: json["TagCount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "ID": id,
//     "SectionID": sectionID,
//     "FlightID": flightId,
//     "TypeID": typeId,
//     "Code": code,
//     "PositionID": positionId,
//     "Bin": bin,
//     "Title": title,
//     "ClassTypeID": classTypeId,
//     "Destination": destination,
//     "ClassList": classList,
//     "DestList": destList,
//     "FROM": from,
//     "To": to,
//     "TagCount": tagCount,
//   };
//
//   factory TagContainer.fromQr(String qr) {
//     String labelAndTypeID = qr.replaceFirst("ConQR:", "");
//     String typeIDStr = labelAndTypeID.split(",").last;
//     String label = labelAndTypeID.split(",").first;
//     int foundTypeID = int.parse(typeIDStr);
//     return TagContainer(
//       id: null,
//       sectionID: 1,
//       typeId: foundTypeID,
//       // flightID: null,
//       // classTypeID: 1,
//       // positionID: -1,
//       // title: BasicClass.settings.containers.firstWhere((element) => element.typeId == foundTypeID).title,
//       title: '',
//       code: label,
//       to: "",
//       from: "",
//       flightId: null, positionId: null, bin: '', tagCount: null,
//     );
//   }
//
//   factory TagContainer.bulk(int? posId) {
//     return const TagContainer(
//       id: -100,
//       typeId: 1,
//       // flightID: null,
//       // classTypeID: 1,
//       // positionID: posId??-1,
//       title: '',
//       code: "",
//       to: "",
//       from: "",
//       // barcodePrefix: "",
//       // ocrPrefix: ["AKE######", "CART######"],
//       flightId: null, positionId: null, bin: '', tagCount: null, sectionID: 1,
//     );
//   }
//
//   bool get isBulk => id==-100;
//
//   String get getQr => "ConQR:$code,$typeId";
//
//   String get rote => ((from??'').isEmpty || (to??'').isEmpty) ? "" : "$from-$to";
//
//   String get type => typeId ==1?'Cart':"ULD";
//
//   String get barcode => '';
//
//   List<String>get  dests => (destList??'').split(",");
//
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
//   // ClassType get classType => BasicClass.getClassTypeByID(classTypeID)!;
//
//   Widget get getImg => isBulk?const SizedBox(): Image.asset(isCart? AssetImages.cart:AssetImages.uld,width: 30,height: 30,);
//
//   List<FlightTag> getTags(FlightDetails fd) {
//     return fd.tagList.where((element) => element.tagPositions.first.container == this).toList();
//   }
//
//   bool validateSearch(String s) {
//     return s.isEmpty || "$code".toLowerCase().contains(s.toLowerCase());
//   }
// }

import 'package:brs_panel/core/classes/login_user_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/assest.dart';
import '../constants/ui.dart';
import '../util/basic_class.dart';
import 'flight_details_class.dart';

class TagContainer {
  TagContainer({
    required this.id,
    required this.flightID,
    required this.typeId,
    required this.positionID,
    required this.classTypeID,
    required this.title,
    required this.code,
    required this.sectionID,
    this.spotID,
    this.binID,
    this.shootID,
    this.dest = "",
    this.from = "",
    this.barcode = "",
    this.barcodePrefix,
    this.flnb,
    this.tagCount = 0,
    this.al,
    this.tagTypeIds,
    // this.isClosed = false,
    this.destList = const [],
    this.classTypeList = const [],
    required this.ocrPrefix,
    this.closedTime,
  });

  int? id;
  int? flightID;
  int? spotID;
  int? binID;
  int? shootID;
  int typeId;
  int sectionID;
  int positionID;
  int classTypeID;
  String title;
  String code;
  String? barcodePrefix;
  String? al;
  String? flnb;
  String? tagTypeIds;
  String dest;
  String from;
  String barcode;
  String? closedTime;
  int tagCount;
  List<String> ocrPrefix;
  List<String> destList;
  List<String> classTypeList;

  // bool isClosed;
  Map<String, dynamic> toJson() => {
    "ID": id,
    "FlightID": flightID,
    "SpotID": spotID,
    "BinID": binID,
    "TypeID": typeId,
    "TagCount": tagCount,
    "ClassTypeID": classTypeID,
    "ShootID": shootID,
    "Title": title,
    "Code": code,
    "Dest": dest,
    "From": from,
    "Barcode": barcode,
    "ClosedTime": closedTime,
    "AL": al,
    "FLNB": flnb,
    "TagTypeIDs": tagTypeIds,
    "DestList": destList.join(","),
    "ClassList": classTypeList.join(","),
    "To": dest,
    "PositionID": positionID,
    "BarcodePrefix": barcodePrefix,
    "OCRPrefix": ocrPrefix,
    // "IsClosed": isClosed
  };

  factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
        id: json["ID"],
        flightID: json["FlightID"],
        binID: json["BinID"],
        sectionID: json["SectionID"] ?? 1,
        typeId: json["TypeID"] ?? 1,
        spotID: json["SpotID"],
        shootID: json["ShootID"],
        classTypeID: json["ClassTypeID"] ?? 1,
        positionID: json["PositionID"] ?? -1,
        title: json["Title"] ?? "",
        closedTime: json["ClosedTime"] ?? "",
        tagCount: json["TagCount"] ?? 0,
        flnb: json["FLNB"] ?? "",
        al: json["AL"] ?? "",
        tagTypeIds: json["TagTypeIDs"] ?? "",
        code: json["Code"] ?? "",
        barcode: json["Barcode"] ?? "",
        dest: json["Dest"] ?? json["To"] ?? "",
        from: json["From"] ?? "",
        // isClosed: json["IsClosed"] ?? false,
        barcodePrefix: json["BarcodePrefix"] ?? "",
        // destList: ((json["DestList"] ?? "") as String).split(","),
        destList: [],
        // classTypeList: ((json["ClassList"] ?? "") as String).split(",").where((element) => element.trim().isNotEmpty).toList(),
        classTypeList: [],
        // ocrPrefix: List<String>.from((json["OCRPrefix"] ?? ["AKE######", "CART######"]).map((x) => x.toString())),
        ocrPrefix: [],
      );

  factory TagContainer.fromQr(String qr) {
    int foundTypeID = 1;
    if (qr.toLowerCase().startsWith("u")) {
      foundTypeID = 2;
    } else {
      foundTypeID = 1;
    }
    // String labelAndTypeID = qr.replaceFirst("ConQR:", "");
    // String typeIDStr = labelAndTypeID.split(",").last;
    // String label = labelAndTypeID.split(",").first;

    return TagContainer(
      id: null,
      typeId: foundTypeID,
      classTypeID: 1,
      positionID: -1,
      sectionID: BasicClass.getAllAirportSections().first.id,
      title: BasicClass.systemSetting.containers.firstWhere((element) => element.typeId == foundTypeID).title,
      code: foundTypeID == 1 ? "CART" : "ULD",
      dest: "",
      from: "",
      // isClosed: false,
      barcodePrefix: "",
      ocrPrefix: ["AKE######", "CART######"],
      flightID: null,
    );
  }

  factory TagContainer.empty() {
    return TagContainer(
      id: 1,
      sectionID: BasicClass.getAllAirportSections().first.id,
      typeId: 1,
      classTypeID: 1,
      positionID: -1,
      title: "",
      code: "ULD",
      dest: "",
      from: "",
      // isClosed: false,
      barcodePrefix: "",
      ocrPrefix: ["AKE######", "CART######"],
      flightID: null,
    );
  }

  factory TagContainer.bulk(int? posId) {
    return TagContainer(
      id: -100,
      typeId: 1,
      // flightID: null,
      // classTypeID: 1,
      // positionID: posId??-1,
      title: '',
      code: "",
      from: "",
      // barcodePrefix: "",
      // ocrPrefix: ["AKE######", "CART######"],
      tagCount: 0,
      sectionID: 1,
      flightID: null,
      positionID: 1,
      classTypeID: 1,
      ocrPrefix: const [],
    );
  }

  // String get getQr => "ConQR:$code,$typeId";
  String get getQr => "${isCart ? 'C' : 'U'}$id";

  String get rote => (from.isEmpty || dest.isEmpty) ? "" : "$from-$dest";

  String get type => typeId == 1 ? 'Cart' : "ULD";

  String get allowedDests => destList.join("").trim().isEmpty ? "All" : destList.join(", ");

  Widget get getImg => Image.asset(typeId == 1 ? AssetImages.cart : AssetImages.uld, width: 44);

  Widget get getImgMini => Stack(
        children: [
          Image.asset(typeId == 1 ? AssetImages.cart : AssetImages.uld, width: 22),
          isClosed
              ? Container(
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(3)),
                  width: 23,
                  height: 23,
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "Closed!",
                    style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
                  ),
                )
              : const SizedBox()
        ],
      );

  Widget get allowedClassesWidget => RichText(
        text: TextSpan(
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          children: classTypeList.where((element) => element.isNotEmpty).isEmpty
              ? [const TextSpan(text: 'All', style: TextStyle(color: Colors.black))]
              : classTypeList
                  .map((e) => BasicClass.getClassTypeByCode(e))
                  .map(
                    (cl) => TextSpan(
                      text: "${cl?.abbreviation}",
                      style: TextStyle(color: cl!.getColor),
                    ),
                  )
                  .toList(),
        ),
      );

  Widget get allowedDestsWidget => Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(color: MyColors.ice, borderRadius: BorderRadius.circular(4)),
        child: Text(
          allowedDests,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );

  Widget get allowedTagTypesWidget => Row(
        mainAxisSize: MainAxisSize.min,
        children: allowedTagTypes.isEmpty
            ? []
            : allowedTagTypes
                .where((element) => element.label.isNotEmpty)
                .map((e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                      decoration: BoxDecoration(color: e.getColor.withOpacity(1), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        e.label,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: e.getTextColor),
                      ),
                    ))
                .toList(),
      );

  Widget get allowedTagTypesWidgetMini => Row(
        mainAxisSize: MainAxisSize.min,
        children: allowedTagTypes.isEmpty
            ? []
            : allowedTagTypes
                .where((element) => element.label.isNotEmpty)
                .map((e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                      decoration: BoxDecoration(color: e.getColor.withOpacity(1), borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        e.label,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: e.getTextColor),
                      ),
                    ))
                .toList(),
      );

  Color get getTypeColor => allowedTagTypes.isEmpty ? Colors.transparent : allowedTagTypes.first.getColor;

  Spot? get getSpot {
    if (spotID == null) return null;
    List<Spot> combinedList = BasicClass.shootList.map((e) => e.spotList).toList().expand((e) => e).toList();
    return combinedList.firstWhere((element) => element.id == spotID);
  }

  Widget get getSpotWidget {
    if (spotID == null) return const SizedBox();

    List<Spot> combinedList = BasicClass.shootList.map((e) => e.spotList).toList().expand((e) => e).toList();
    return Container(
        width: 45,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: MyColors.myGreen.withOpacity(0.4)),
        child: Text(
          combinedList.firstWhereOrNull((element) => element.id == spotID)?.spot ?? '$spotID',
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
        ));
  }

  get isClosed => (closedTime ?? '').isNotEmpty;

  Position? get getPosition => BasicClass.getPositionById(positionID);



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

  ClassType get classType => BasicClass.systemSetting.classTypeList.firstWhere((element) => element.id == classTypeID);

  List<FlightTag> getTags(FlightDetails fd) {
    final res = fd.tagList.where((element) => element.tagPositions.first.container == this).toList();
    // print(res.map((e) => e.tagPositions.first.container?.id));
    return res;
  }

  validateSearch(String searched) {
    return (code.toLowerCase().contains(searched.toLowerCase()) || searched == "") || (searched.toLowerCase().trim() == barcode.toLowerCase().trim());
  }

  List<TagType> get allowedTagTypes => BasicClass.systemSetting.tagTypeList.where((tt) => (tagTypeIds ?? '').split(",").contains(tt.id.toString())).toList();
}
