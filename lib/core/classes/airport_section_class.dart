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
        airport: json["Airport"],
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
  final int id;
  final String label;
  final int position;
  final int offset;
  final bool isMainSection;
  final bool canHaveTag;
  final bool canHaveContainer;
  final bool canHaveBin;
  final bool spotRequired;
  final List<SubCategory> subCategories;

  const Section({
    required this.id,
    required this.label,
    required this.position,
    required this.offset,
    required this.isMainSection,
    required this.canHaveTag,
    required this.canHaveContainer,
    required this.canHaveBin,
    required this.spotRequired,
    required this.subCategories,
  });

  Section copyWith({
    int? id,
    String? label,
    int? position,
    int? offset,
    bool? isMainSection,
    bool? canHaveTag,
    bool? canHaveContainer,
    bool? canHaveBin,
    bool? spotRequired,
    List<SubCategory>? subCategories,
  }) =>
      Section(
        id: id ?? this.id,
        label: label ?? this.label,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        isMainSection: isMainSection ?? this.isMainSection,
        canHaveTag: canHaveTag ?? this.canHaveTag,
        canHaveContainer: canHaveContainer ?? this.canHaveContainer,
        canHaveBin: canHaveBin ?? this.canHaveBin,
        spotRequired: spotRequired ?? this.spotRequired,
        subCategories: subCategories ?? this.subCategories,
      );

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["ID"],
        label: json["Label"],
        position: json["Position"],
        offset: json["Offset"],
        isMainSection: json["IsMainSection"],
        canHaveTag: json["CanHaveTag"],
        canHaveContainer: json["CanHaveContainer"],
        canHaveBin: json["CanHaveBin"],
        spotRequired: json["SpotRequired"],
        subCategories: List<SubCategory>.from((json["SUBS"] ?? []).map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Position": position,
        "Offset": offset,
        "IsMainSection": isMainSection,
        "CanHaveTag": canHaveTag,
        "CanHaveContainer": canHaveContainer,
        "CanHaveBin": canHaveBin,
        "SpotRequired": spotRequired,
        "SUBS": List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };

  validateSearch(String s) {
    return null;
  }
}

@immutable
class SubCategory {
  final int id;
  final String label;
  final int position;
  final int offset;
  final bool isMainSection;
  final bool canHaveTag;
  final bool canHaveContainer;
  final bool canHaveBin;
  final bool spotRequired;
  final List<SubCategory> subCategories;

  const SubCategory({
    required this.id,
    required this.label,
    required this.position,
    required this.offset,
    required this.isMainSection,
    required this.canHaveTag,
    required this.canHaveContainer,
    required this.canHaveBin,
    required this.spotRequired,
    required this.subCategories,
  });

  SubCategory copyWith({
    int? id,
    String? label,
    int? position,
    int? offset,
    bool? isMainSection,
    bool? canHaveTag,
    bool? canHaveContainer,
    bool? canHaveBin,
    bool? spotRequired,
    List<SubCategory>? subCategories,
  }) =>
      SubCategory(
        id: id ?? this.id,
        label: label ?? this.label,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        isMainSection: isMainSection ?? this.isMainSection,
        canHaveTag: canHaveTag ?? this.canHaveTag,
        canHaveContainer: canHaveContainer ?? this.canHaveContainer,
        canHaveBin: canHaveBin ?? this.canHaveBin,
        spotRequired: spotRequired ?? this.spotRequired,
        subCategories: subCategories ?? this.subCategories,
      );

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["ID"],
        label: json["Label"],
        position: json["Position"],
        offset: json["Offset"],
        isMainSection: json["IsMainSection"],
        canHaveTag: json["CanHaveTag"],
        canHaveContainer: json["CanHaveContainer"],
        canHaveBin: json["CanHaveBin"],
        spotRequired: json["SpotRequired"],
        subCategories: List<SubCategory>.from((json["SUBS"] ?? []).map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Label": label,
        "Position": position,
        "Offset": offset,
        "IsMainSection": isMainSection,
        "CanHaveTag": canHaveTag,
        "CanHaveContainer": canHaveContainer,
        "CanHaveBin": canHaveBin,
        "SpotRequired": spotRequired,
        "SUBS": List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };

  validateSearch(String s) {
    return null;
  }
}
