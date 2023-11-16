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
  final bool canHaveTag;
  final bool canHaveContainer;
  final bool canHaveBin;
  final bool spotRequired;
  final List<Section> sections;

  const Section({
    required this.id,
    required this.label,
    required this.code,
    required this.position,
    required this.offset,
    required this.isMainSection,
    required this.canHaveTag,
    required this.canHaveContainer,
    required this.canHaveBin,
    required this.spotRequired,
    required this.sections,
  });

  Section copyWith({
    int? id,
    String? label,
    String? code,
    int? position,
    int? offset,
    bool? isMainSection,
    bool? canHaveTag,
    bool? canHaveContainer,
    bool? canHaveBin,
    bool? spotRequired,
    List<Section>? sections,
  }) =>
      Section(
        id: id ?? this.id,
        label: label ?? this.label,
        code: code ?? this.code,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        isMainSection: isMainSection ?? this.isMainSection,
        canHaveTag: canHaveTag ?? this.canHaveTag,
        canHaveContainer: canHaveContainer ?? this.canHaveContainer,
        canHaveBin: canHaveBin ?? this.canHaveBin,
        spotRequired: spotRequired ?? this.spotRequired,
        sections: sections ?? this.sections,
      );

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["ID"],
        label: json["Label"],
        code: json["Code"],
        position: json["Position"],
        offset: json["Offset"],
        isMainSection: json["IsMainSection"],
        canHaveTag: json["CanHaveTag"],
        canHaveContainer: json["CanHaveContainer"],
        canHaveBin: json["CanHaveBin"],
        spotRequired: json["SpotRequired"],
        sections: List<Section>.from((json["SUBS"] ?? []).map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Code": code,
        "Position": position,
        "Offset": offset,
        "IsMainSection": isMainSection,
        "CanHaveTag": canHaveTag,
        "CanHaveContainer": canHaveContainer,
        "CanHaveBin": canHaveBin,
        "SpotRequired": spotRequired,
        "SUBS": List<dynamic>.from(sections.map((x) => x.toJson())),
      };

  validateSearch(String s) {
    return null;
  }
}
