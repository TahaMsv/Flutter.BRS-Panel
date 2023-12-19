import 'package:flutter/material.dart';

@immutable
class AirportSections {
  final String airport;
  final List<Section> sections;

  const AirportSections({
    required this.airport,
    required this.sections,
  });

  AirportSections copyWith({
    String? airport,
    List<Section>? sections,
  }) =>
      AirportSections(
        airport: airport ?? this.airport,
        sections: sections ?? this.sections,
      );

  factory AirportSections.fromJson(Map<String, dynamic> json) => AirportSections(
        airport: json["Airport"] ?? "",
        sections: List<Section>.from((json["Section"] ?? []).map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Airport": airport,
        "Section": List<dynamic>.from(sections.map((x) => x.toJson())),
      };

  validateSearch(String s) {
    return null;
  }
}

@immutable
class Section {
  final int? id;
  final String label;
  final String code;
  final int position;
  final int offset;
  final bool isMainSection;
  final bool? isGround;
  final int? groundSectionID;
  final bool canHaveTag;
  final bool canHaveContainer;
  final bool canHaveBin;
  final bool spotRequired;
  final List<SectionSpot> spots;
  final List<Section> sections;

  const Section({
    required this.id,
    required this.label,
    required this.code,
    required this.position,
    required this.offset,
    required this.isMainSection,
    required this.isGround,
    required this.groundSectionID,
    required this.canHaveTag,
    required this.canHaveContainer,
    required this.canHaveBin,
    required this.spotRequired,
    required this.spots,
    required this.sections,
  });

  Section copyWith({
    int? id,
    String? label,
    String? code,
    int? position,
    int? offset,
    bool? isMainSection,
    bool? isGround,
    int? groundSectionID,
    bool? canHaveTag,
    bool? canHaveContainer,
    bool? canHaveBin,
    bool? spotRequired,
    List<SectionSpot>? spots,
    List<Section>? sections,
  }) =>
      Section(
        id: id ?? this.id,
        label: label ?? this.label,
        code: code ?? this.code,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        isMainSection: isMainSection ?? this.isMainSection,
        isGround: isGround ?? this.isGround,
        groundSectionID: groundSectionID ?? this.groundSectionID,
        canHaveTag: canHaveTag ?? this.canHaveTag,
        canHaveContainer: canHaveContainer ?? this.canHaveContainer,
        canHaveBin: canHaveBin ?? this.canHaveBin,
        spotRequired: spotRequired ?? this.spotRequired,
        spots: spots ?? this.spots,
        sections: sections ?? this.sections,
      );

  factory Section.empty() => const Section(
      id: null,
      label: "",
      code: "",
      position: 0,
      offset: 0,
      isMainSection: false,
      isGround: null,
      groundSectionID: null,
      canHaveTag: true,
      canHaveContainer: false,
      canHaveBin: false,
      spotRequired: false,
      spots: [],
      sections: []);

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["ID"],
        label: json["Label"],
        code: json["Code"],
        position: json["Position"],
        offset: json["Offset"],
        isMainSection: json["IsMainSection"],
        isGround: json["IsGround"],
        groundSectionID: json["GroundSectionID"],
        canHaveTag: json["CanHaveTag"],
        canHaveContainer: json["CanHaveContainer"],
        canHaveBin: json["CanHaveBin"],
        spotRequired: json["SpotRequired"],
        spots: List<SectionSpot>.from((json["SpotList"] ?? []).map((x) => SectionSpot.fromJson(x))),
        sections: List<Section>.from((json["SUBS"] ?? []).map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Code": code,
        "Position": position,
        "Offset": offset,
        "IsMainSection": isMainSection,
        "IsGround": isGround,
        "GroundSectionID": groundSectionID,
        "CanHaveTag": canHaveTag,
        "CanHaveContainer": canHaveContainer,
        "CanHaveBin": canHaveBin,
        "SpotRequired": spotRequired,
        "SpotList": List<dynamic>.from(spots.map((x) => x.toJson())),
        "SUBS": List<dynamic>.from(sections.map((x) => x.toJson())),
      };

  List<Section> get subSections {
    List<Section> hier = [];
    if (sections.isEmpty) return hier;
    for (var s in sections) {
      hier = hier + s.subSections.map((e) => e.copyWith()).toList();
    }
    return hier;
  }

  validateSearch(String s) {
    return null;
  }
}

class SectionSpot {
  final int? id;
  final String label;

  SectionSpot({required this.id, required this.label});

  SectionSpot copyWith({int? id, String? label}) => SectionSpot(id: id ?? this.id, label: label ?? this.label);

  factory SectionSpot.fromJson(Map<String, dynamic> json) => SectionSpot(id: json["ID"], label: json["Label"]);

  Map<String, dynamic> toJson() => {"ID": id, "Label": label};
}
