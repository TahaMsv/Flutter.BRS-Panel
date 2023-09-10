class Config {
  Config({
    required this.appName,
    required this.company,
    required this.baseURL,
  });

  final String appName;
  final String company;
  final String baseURL;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    appName: json["AppName"],
    company: json["Company"],
    baseURL: json["BaseURL"],
  );

  factory Config.def() => Config(
    appName: 'BRS-Panel',
    company: 'Abomis',
    baseURL: 'https://brsStage-api-descktop.abomis.com/jsn',
    // baseURL: 'https://brsStaging-api.abomis.com/BRS',

    // baseURL: 'https://brsstaging-api.abomis.com/BRS',
    // baseURL: 'https://brsDev-api-desktop.abomis.com/jsn',
  );

  Map<String, dynamic> toJson() => {
    "AppName": appName,
    "Company": company,
    "BaseURL": baseURL,
  };
}
