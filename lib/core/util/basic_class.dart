import 'package:brs_panel/core/abstracts/local_data_base_abs.dart';
import '../abstracts/device_info_service_abs.dart';
import '../classes/login_user_class.dart';
import '../constants/apis.dart';
import 'config_class.dart';

class BasicClass {
  BasicClass._();

  factory BasicClass() {
    return instance;
  }

  static final BasicClass instance = BasicClass._();
  static late bool initialized;
  UserSettings? _userSettings;
  SystemSettings? _systemSettings;
  LoginUser? _userInfo;
  Airport? _airport;
  ScreenType? _deviceType;
  Config? _appConfig;

  static void initialize(LoginUser user, ScreenType deviceType) {
    instance._userInfo = user;
    instance._userSettings = user.userSettings;
    instance._systemSettings = user.systemSettings;
    instance._deviceType = deviceType;
    instance._airport = user.systemSettings.airportList.firstWhere((element) => element.code == user.userSettings.airport);
  }

  static void setConfig(Config config) {
    instance._appConfig = config;
  }

  static Airport get airport => instance._airport ?? Airport.empty();

  static String get username => instance._userInfo?.username ?? "";

  static String get profileUrl => Apis.getProfileImage(instance._userInfo?.username ?? "");

  static List<String> get airlineList => instance._userSettings?.accessAirlines ?? [];

  static SystemSettings get systemSetting => instance._systemSettings ?? SystemSettings.empty();

  static UserSettings get userSetting => instance._userSettings ?? UserSettings.empty();

  static LoginUser get userInfo => instance._userInfo ?? LoginUser.empty();

  static Config get config => instance._appConfig ?? Config.def();

  // static MyDeviceInfo get deviceInfo => instance._deviceInfo??MyDeviceInfo();
  static ScreenType get deviceType => instance._deviceType ?? ScreenType.phone;

  static Position? getPositionByID(int? id) {
    return systemSetting.positions.firstWhereOrNull((e) => e.id == id);
  }

  static TagAction? getExceptionByID(int? id) {
    return systemSetting.exceptionStatusList.firstWhereOrNull((e) => e.id == id);
  }

  static Airport? getAirportByCode(String code) {
    return systemSetting.airportList.firstWhereOrNull((e) => e.code == code);
  }

  static String? getAirlineByCode(String code) {
    return userSetting.accessAirlines.firstWhereOrNull((e) => e == code);
  }

  static Aircraft? getAircraftByID(int? id) {
    return systemSetting.aircraftList.firstWhereOrNull((e) => e.id == id);
  }

  static ClassType? getClassTypeByID(int id) {
    return systemSetting.classTypeList.firstWhereOrNull((e) => e.id == id);
  }

  static TagType? getTagTypeByID(int id) {
    return systemSetting.tagTypeList.firstWhereOrNull((e) => e.id == id);
  }

  static ClassType? getClassTypeByCode(String code) {
    return systemSetting.classTypeList.firstWhereOrNull((e) => e.abbreviation == code);
  }

  static TagStatus? getTagStatusByID(int id) {
    return systemSetting.statusList.firstWhereOrNull((e) => e.id == id);
  }

  static Position? getPositionById(int id) {
    return systemSetting.positions.firstWhereOrNull((e) => e.id == id);
  }

  static TagStatus? getTagStatusById(int id) {
    return systemSetting.statusList.firstWhereOrNull((e) => e.id == id);
  }

  static List<AirportPositionSection> getAllAirportSections() {
    List<AirportPositionSection> secs = [];
    for (var s in userSetting.hierarchy) {
      secs = secs + s.subSections.map((e) => e.copyWith(address: "${e.address}${e.label}")).toList();
    }
    return secs;
  }

  static List<AirportPositionSection> getAllAirportSections1() {
    List<AirportPositionSection> secs = [];
    for (var s in userSetting.hierarchy) {
      List<AirportPositionSection> sections = getAllAirportSections2(s);
      secs = secs + sections;
    }
    return secs;
  }

  static List<AirportPositionSection> getAllAirportSections2(AirportPositionSection s) {
    List<AirportPositionSection> secs = [s.copyWith(address: "${s.address}${s.label}")];
    for (var sub in s.subs) {
      List<AirportPositionSection> sections = getAllAirportSections2(sub);
      secs = secs + sections;
    }
    return secs;
  }

  static List<AirportPositionSection> getAllAirportSections4() {
    List<AirportPositionSection> secs = [];
    for (var s in userSetting.hierarchy) {
      secs = secs + s.subSections.map((e) => e.copyWith(address: "${e.address}${e.label}")).toList();
    }
    return secs;
  }

  static AirportPositionSection? getAirportSectionByID(int sectionID) {
    return BasicClass.getAllAirportSections().firstWhereOrNull((element) => element.id == sectionID);
  }

  static DateTime? getTimeFromUTC(DateTime? dt) {
    return dt?.add(Duration(minutes: airport.timeZone));
  }

  static HandlingAccess? getHandlingByID(int? handlingID) {
    return BasicClass.systemSetting.handlingAccess.firstWhereOrNull((element) => element.id == handlingID);
  }

  static setAirport(Airport ap) {
    instance._airport = ap;
  }
}
