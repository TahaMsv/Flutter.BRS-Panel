class SpecialReportResult {
  SpecialReportResult({
    required this.dataHeaders,
    required this.dataRows,
  });

  List<String> dataHeaders;
  List<List<dynamic>> dataRows;

  factory SpecialReportResult.fromJson(Map<String, dynamic> json) => SpecialReportResult(
      dataHeaders: List<String>.from(json["DataHeaders"].map((x) => x)),
      // dataRows: List<List<String>>.from((json["DataRows"]).map((x) => Map.from(x).values.toList())),
      dataRows: (json["DataRows"] as List).map((x) {
        return (x as Map<String, dynamic>).values.toList();
      }).toList());

  Map<String, dynamic> toJson() => {
        "DataHeaders": List<dynamic>.from(dataHeaders.map((x) => x)),
        "DataRows": List<dynamic>.from(dataRows.map((x) => Map.fromEntries(dataHeaders.map((e) => MapEntry(e, x[dataHeaders.indexOf(e)]))))),
      };

  factory SpecialReportResult.example() => SpecialReportResult(dataHeaders: [
        "Name",
        "LastName",
        "Age",
        "Group"
      ], dataRows: [
        ["a", "b", null, "zzzz"],
        ["aaas", "beee", 330, "llll"],
      ]);
}
