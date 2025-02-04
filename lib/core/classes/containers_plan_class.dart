import 'flight_class.dart';

class ContainersPlan {
  final int flightId;
  final int sectionID;
  final int? spotID;
  final String statustics;
  final int cartCap;
  final int uldCap;
  final Flight? lastFligt;
  final List<PlanDatum> lastFlightPlanData;
  final List<PlanDatum> planData;

  ContainersPlan({
    required this.flightId,
    required this.sectionID,
    required this.spotID,
    required this.statustics,
    required this.cartCap,
    required this.uldCap,
    required this.lastFligt,
    required this.lastFlightPlanData,
    required this.planData,
  });

  ContainersPlan copyWith({
    int? flightId,
    int? sectionID,
    int? spotID,
    String? statustics,
    int? cartCap,
    int? uldCap,
    Flight? lastFligt,
    List<PlanDatum>? lastFlightPlanData,
    List<PlanDatum>? planData,
  }) =>
      ContainersPlan(
        flightId: flightId ?? this.flightId,
        sectionID: sectionID ?? this.sectionID,
        spotID: spotID ?? this.spotID,
        statustics: statustics ?? this.statustics,
        cartCap: cartCap ?? this.cartCap,
        uldCap: uldCap ?? this.uldCap,
        lastFligt: lastFligt ?? this.lastFligt,
        lastFlightPlanData: lastFlightPlanData ?? this.lastFlightPlanData,
        planData: planData ?? this.planData,
      );

  factory ContainersPlan.fromJson(Map<String, dynamic> json) => ContainersPlan(
        flightId: json["FlightID"],
        sectionID: json["SectionID"],
        spotID: json["SpotID"],
        statustics: json["Statustics"],
        cartCap: json["CartCap"],
        uldCap: json["ULDCap"],
        lastFligt: json["LastFligt"] == null ? null : Flight.fromJson(json["LastFligt"]),
        lastFlightPlanData: List<PlanDatum>.from(json["LastFlightPlanData"].map((x) => PlanDatum.fromJson(x))),
        planData: List<PlanDatum>.from(json["PlanData"].map((x) => PlanDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "FlightID": flightId,
        "SectionID": sectionID,
        "SpotID": spotID,
        "Statustics": statustics,
        "CartCap": cartCap,
        "ULDCap": uldCap,
        "LastFligt": lastFligt?.toJson(),
        "LastFlightPlanData": List<dynamic>.from(lastFlightPlanData.map((x) => x.toJson())),
        "PlanData": List<dynamic>.from(planData.map((x) => x.toJson())),
      };
}

class PlanDatum {
  final int? planeID;
  final List<int> tagTypeId;
  final int cartCount;
  final int uldCount;

  PlanDatum({
    required this.planeID,
    required this.tagTypeId,
    required this.cartCount,
    required this.uldCount,
  });

  PlanDatum copyWith({
    int? planeID,
    List<int>? tagTypeId,
    int? cartCount,
    int? uldCount,
  }) =>
      PlanDatum(
        planeID: planeID ?? this.planeID,
        tagTypeId: tagTypeId ?? this.tagTypeId,
        cartCount: cartCount ?? this.cartCount,
        uldCount: uldCount ?? this.uldCount,
      );

  factory PlanDatum.fromJson(Map<String, dynamic> json) => PlanDatum(
        planeID: json["PlaneID"],
        tagTypeId: List<int>.from(json["TagTypeID"].map((x) => x)),
        cartCount: json["CartCount"],
        uldCount: json["ULDCount"],
      );

  Map<String, dynamic> toJson() => {
        "PlaneID": planeID,
        "TagTypeID": tagTypeId,
        "CartCount": cartCount,
        "ULDCount": uldCount,
      };

  factory PlanDatum.empty() {
    return PlanDatum(planeID: null, tagTypeId: [], cartCount: 0, uldCount: 0);
  }
}

class LastFligt {
  final String al;
  final String flnb;
  final DateTime flightDate;

  LastFligt({
    required this.al,
    required this.flnb,
    required this.flightDate,
  });

  LastFligt copyWith({
    String? al,
    String? flnb,
    DateTime? flightDate,
  }) =>
      LastFligt(
        al: al ?? this.al,
        flnb: flnb ?? this.flnb,
        flightDate: flightDate ?? this.flightDate,
      );

  factory LastFligt.fromJson(Map<String, dynamic> json) => LastFligt(
        al: json["AL"],
        flnb: json["FLNB"],
        flightDate: DateTime.parse(json["FlightDate"]),
      );

  Map<String, dynamic> toJson() => {
        "AL": al,
        "FLNB": flnb,
        "FlightDate": "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
      };
}
