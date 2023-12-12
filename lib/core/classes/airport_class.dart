import '../enums/daylight_saving_region_enum.dart';

class DetailedAirports {
  final List<DetailedAirport> airports;

  DetailedAirports({required this.airports});

  DetailedAirports copyWith({List<DetailedAirport>? airports}) => DetailedAirports(airports: airports ?? this.airports);

  factory DetailedAirports.fromJson(Map<String, dynamic> json) => DetailedAirports(
        airports: List<DetailedAirport>.from(json["Airports"].map((x) => DetailedAirport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Airports": List<dynamic>.from(airports.map((x) => x.toJson())),
      };
}

class DetailedAirport {
  final String code;
  final int? isDomestic;
  final String? showName;
  final String? cityName;
  final dynamic cityNameFa;
  final String? airportName;
  final dynamic airportNameFa;
  final String? countryCode2;
  final String? countryName;
  final dynamic countryNameFa;
  final dynamic worldAreaCode;
  final bool? active;
  final bool? isDeleted;
  final String? timeZone;
  final String? strTimeZone;
  final DaylightSavingRegion? daylightSavingRegion;
  final bool? daylightSaving;
  final int timezone;

  const DetailedAirport({
    required this.code,
    required this.isDomestic,
    required this.showName,
    required this.cityName,
    required this.cityNameFa,
    required this.airportName,
    required this.airportNameFa,
    required this.countryCode2,
    required this.countryName,
    required this.countryNameFa,
    required this.worldAreaCode,
    required this.active,
    required this.isDeleted,
    required this.timeZone,
    required this.daylightSavingRegion,
    required this.daylightSaving,
    required this.timezone,
    required this.strTimeZone,
  });

  DetailedAirport copyWith({
    String? code,
    int? isDomestic,
    String? showName,
    String? cityName,
    dynamic cityNameFa,
    String? airportName,
    dynamic airportNameFa,
    String? countryCode2,
    String? countryName,
    dynamic countryNameFa,
    dynamic worldAreaCode,
    bool? active,
    bool? isDeleted,
    String? timeZone,
    DaylightSavingRegion? daylightSavingRegion,
    bool? daylightSaving,
    int? timezone,
    String? strTimeZone,
  }) =>
      DetailedAirport(
        code: code ?? this.code,
        isDomestic: isDomestic ?? this.isDomestic,
        showName: showName ?? this.showName,
        cityName: cityName ?? this.cityName,
        cityNameFa: cityNameFa ?? this.cityNameFa,
        airportName: airportName ?? this.airportName,
        airportNameFa: airportNameFa ?? this.airportNameFa,
        countryCode2: countryCode2 ?? this.countryCode2,
        countryName: countryName ?? this.countryName,
        countryNameFa: countryNameFa ?? this.countryNameFa,
        worldAreaCode: worldAreaCode ?? this.worldAreaCode,
        active: active ?? this.active,
        isDeleted: isDeleted ?? this.isDeleted,
        timeZone: timeZone ?? this.timeZone,
        daylightSavingRegion: daylightSavingRegion ?? this.daylightSavingRegion,
        daylightSaving: daylightSaving ?? this.daylightSaving,
        timezone: timezone ?? this.timezone,
        strTimeZone: strTimeZone ?? this.strTimeZone,
      );

  factory DetailedAirport.fromJson(Map<String, dynamic> json) => DetailedAirport(
        code: json["Code"],
        isDomestic: json["Is_Domestic"],
        showName: json["Show_Name"],
        cityName: json["CityName"],
        cityNameFa: json["City_Name_Fa"],
        airportName: json["Airport_Name"],
        airportNameFa: json["Airport_Name_Fa"],
        countryCode2: json["Country_Code2"],
        countryName: json["Country_Name"],
        countryNameFa: json["Country_Name_Fa"],
        worldAreaCode: json["World_Area_Code"],
        active: json["Active"],
        isDeleted: json["IsDeleted"],
        timeZone: json["TimeZone"],
        daylightSavingRegion: daylightSavingRegionValues.map[json["DaylightSavingRegion"]],
        daylightSaving: json["DaylightSaving"],
        timezone: json["Timezone"],
        strTimeZone: json["STRTimeZone"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Is_Domestic": isDomestic,
        "Show_Name": showName,
        "CityName": cityName,
        "City_Name_Fa": cityNameFa,
        "Airport_Name": airportName,
        "Airport_Name_Fa": airportNameFa,
        "Country_Code2": countryCode2,
        "Country_Name": countryName,
        "Country_Name_Fa": countryNameFa,
        "World_Area_Code": worldAreaCode,
        "Active": active,
        "IsDeleted": isDeleted,
        "TimeZone": timeZone,
        "DaylightSavingRegion": daylightSavingRegionValues.reverse[daylightSavingRegion],
        "DaylightSaving": daylightSaving,
        "Timezone": timezone,
        "STRTimeZone": strTimeZone,
      };

  validateSearch(String s) {
    return s.isEmpty || "$code $cityName".toLowerCase().contains(s.toLowerCase());
  }
}
