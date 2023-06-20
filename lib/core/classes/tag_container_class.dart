import 'package:brs_panel/core/classes/user_class.dart';
import 'package:flutter/cupertino.dart';

import '../constants/assest.dart';
import '../util/basic_class.dart';
import 'flight_details_class.dart';

@immutable
class TagContainer {
  final int? id;
  final int? flightId;
  final int typeId;
  final String code;
  final int? positionId;
  final String bin;
  final String title;
  final String? closedTime;
  final int? classTypeId;
  final String? destination;
  final String? classList;
  final String? destList;
  final String? from;
  final String? to;
  final int? tagCount;

  const TagContainer({
    required this.id,
    this.flightId,
    this.typeId=1,
    required this.code,
    required this.positionId,
    this.bin ='',
    required this.title,
     this.closedTime,
     this.classTypeId,
     this.destination,
     this.classList,
     this.destList,
     this.from,
     this.to,
    this.tagCount,
  });

  Position? get getPosition => BasicClass.getPositionByID(positionId);
  List<ClassType>? get getClassTypes => (classList??'').split(",").map((e) => BasicClass.getClassTypeByCode(e)!).toList();

  TagContainer copyWith({
    int? id,
    int? flightId,
    int? typeId,
    String? code,
    int? positionId,
    String? bin,
    String? title,
    String? closedTime,
    int? classTypeId,
    String? destination,
    String? classList,
    String? destList,
    String? from,
    String? to,
    int? tagCount,
  }) =>
      TagContainer(
        id: id ?? this.id,
        flightId: flightId ?? this.flightId,
        typeId: typeId ?? this.typeId,
        code: code ?? this.code,
        positionId: positionId ?? this.positionId,
        bin: bin ?? this.bin,
        title: title ?? this.title,
        closedTime: closedTime ?? this.closedTime,
        classTypeId: classTypeId ?? this.classTypeId,
        destination: destination ?? this.destination,
        classList: classList ?? this.classList,
        destList: destList ?? this.destList,
        from: from ?? this.from,
        to: to ?? this.to,
        tagCount: tagCount ?? this.tagCount,
      );

  factory TagContainer.fromJson(Map<String, dynamic> json) => TagContainer(
    id: json["ID"],
    flightId: json["FlightID"],
    typeId: json["TypeID"],
    code: json["Code"]??'',
    positionId: json["PositionID"],
    bin: json["Bin"]??'',
    title: json["Title"],
    closedTime: json["ClosedTime"],
    classTypeId: json["ClassTypeID"],
    destination: json["Destination"],
    classList: json["ClassList"],
    destList: json["DestList"],
    from: json["FROM"],
    to: json["To"],
    tagCount: json["TagCount"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "FlightID": flightId,
    "TypeID": typeId,
    "Code": code,
    "PositionID": positionId,
    "Bin": bin,
    "Title": title,
    "ClassTypeID": classTypeId,
    "Destination": destination,
    "ClassList": classList,
    "DestList": destList,
    "FROM": from,
    "To": to,
    "TagCount": tagCount,
  };

  factory TagContainer.fromQr(String qr) {
    String labelAndTypeID = qr.replaceFirst("ConQR:", "");
    String typeIDStr = labelAndTypeID.split(",").last;
    String label = labelAndTypeID.split(",").first;
    int foundTypeID = int.parse(typeIDStr);
    return TagContainer(
      id: null,
      typeId: foundTypeID,
      // flightID: null,
      // classTypeID: 1,
      // positionID: -1,
      // title: BasicClass.settings.containers.firstWhere((element) => element.typeId == foundTypeID).title,
      title: '',
      code: label,
      to: "",
      from: "",
      flightId: null, positionId: null, bin: '', tagCount: null,
    );
  }

  factory TagContainer.bulk(int? posId) {
    return const TagContainer(
      id: -100,
      typeId: 1,
      // flightID: null,
      // classTypeID: 1,
      // positionID: posId??-1,
      title: '',
      code: "",
      to: "",
      from: "",
      // barcodePrefix: "",
      // ocrPrefix: ["AKE######", "CART######"],
      flightId: null, positionId: null, bin: '', tagCount: null,
    );
  }

  bool get isBulk => id==-100;

  String get getQr => "ConQR:$code,$typeId";

  String get rote => ((from??'').isEmpty || (to??'').isEmpty) ? "" : "$from-$to";

  String get type => typeId ==1?'Cart':"ULD";

  String get barcode => '';

  List<String>get  dests => (destList??'').split(",");


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

  // ClassType get classType => BasicClass.getClassTypeByID(classTypeID)!;

  Widget get getImg => isBulk?const SizedBox(): Image.asset(isCart? AssetImages.cart:AssetImages.uld,width: 30,height: 30,);

  List<FlightTag> getTags(FlightDetails fd) {
    return fd.tagList.where((element) => element.tagPositions.first.container == this).toList();
  }

  bool validateSearch(String s) {
    return s.isEmpty || "$code".toLowerCase().contains(s.toLowerCase());
  }
}
