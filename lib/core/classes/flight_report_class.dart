class FlightReport {
  final String reportText;

  FlightReport({
    required this.reportText,
  });

  FlightReport copyWith({
    String? reportText,
  }) =>
      FlightReport(
        reportText: reportText ?? this.reportText,
      );

  factory FlightReport.fromJson(Map<String, dynamic> json) => FlightReport(
    reportText: json["ReportText"],
  );

  Map<String, dynamic> toJson() => {
    "ReportText": reportText,
  };
}
