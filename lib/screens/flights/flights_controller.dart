import 'dart:convert';
import 'dart:io';
import 'package:brs_panel/core/abstracts/failures_abs.dart';
import 'package:brs_panel/core/abstracts/success_abs.dart';
import 'package:brs_panel/core/navigation/route_names.dart';
import 'package:brs_panel/core/util/handlers/success_handler.dart';
import 'package:brs_panel/core/util/pickers.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/screens/flights/data_tables/flight_data_table.dart';
import 'package:brs_panel/screens/flights/dialogs/flight_container_list_dialog.dart';
import 'package:brs_panel/screens/flights/dialogs/flight_report_dialog.dart';
import 'package:brs_panel/screens/flights/usecases/flight_add_remove_container_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_container_list_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_containers_plan_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_plan_file.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_report_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_save_containers_plan_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_send_report_usecase.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/device_info_service_abs.dart';
import '../../core/classes/containers_plan_class.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_report_class.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/constants/apis.dart';
import '../../core/constants/data_bases_keys.dart';
import '../../core/data_base/web_data_base.dart';
import '../../core/enums/flight_type_filter_enum.dart';
import '../../core/platform/device_info.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import 'package:path/path.dart' as p;
import '../flight_details/dialogs/pdf_preview_dialog.dart';
import 'dialogs/containers_plan_dialog.dart';
import 'flights_state.dart';

class FlightsController extends MainController {
  late FlightsState flightsState = ref.read(flightsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  @override
  onInit() {
    print("FlightsController onInit");
    // prefs.setBool(SpKeys.flightVFirstInit, false);
    // flightsState.firstInit = false;
    flightList(ref.read(flightDateProvider.notifier).state);
  }

  Future<List<Flight>?> flightList(DateTime dt) async {
    final flightDateP = ref.read(flightDateProvider.notifier);
    flightDateP.state = dt;
    // await SessionStorage().setString(SsKeys.flightDateP, dt.toIso8601String());
    List<Flight>? flights;
    flightsState.loadingFlights = true;
    flightsState.setState();
    FlightListUseCase flightListUsecase = FlightListUseCase();
    FlightListRequest flightListRequest = FlightListRequest(dateTime: dt);
    final fOrR = await flightListUsecase(request: flightListRequest);
    flightsState.loadingFlights = false;
    flightsState.setState();
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightList(dt)), (r) {
      flights = r.flights;
      final fl = ref.read(flightListProvider.notifier);
      fl.setFlights(flights!);
    });
    return flights;
  }

  Future<void> retrieveFlightsScreenFromLocalStorage() async {
    // late DateTime savedDateTime;
    // final savedDateTimeString = await SessionStorage().getString(SsKeys.flightDateP) ?? '';
    // savedDateTime = savedDateTimeString.isNotEmpty ? DateTime.parse(savedDateTimeString) : DateTime.now();
    await flightList(DateTime.now());
    // String? flightAirportFilterPString = await SessionStorage().getString(SsKeys.flightAirportFilterP);
    // String? flightAirlineFilterPString = await SessionStorage().getString(SsKeys.flightAirlineFilterP);
    // final fapfP = ref.watch(flightAirportFilterProvider.notifier);
    // print(flightAirportFilterPString.runtimeType);
    // fapfP.state = flightAirportFilterPString == "null" ? null : Airport.fromJson(jsonDecode(flightAirportFilterPString!));
    // final falP = ref.watch(flightAirlineFilterProvider.notifier);
    // falP.state = (flightAirlineFilterPString == "null" || flightAirlineFilterPString == "") ? null : flightAirlineFilterPString;
    // String flightTypeFilterPString = await SessionStorage().getString(SsKeys.flightTypeFilterP) ?? "";
    // ref.read(flightTypeFilterProvider.notifier).state = getFlightTypeFilterFromString(flightTypeFilterPString);
  }

  void goAddFlight() {
    nav.pushNamed(RouteNames.addFlight);
  }

  void goDetails(Flight f, {Position? selectedPos}) {
    final sfP = ref.read(selectedFlightProvider.notifier);
    sfP.state = f;
    SessionStorage().setString(SsKeys.selectedFlightP, jsonEncode(f.toJson()));
    final spP = ref.read(selectedPosInDetails.notifier);
    spP.state = BasicClass.getPositionByID(selectedPos?.id ?? f.positions.first.id)!;
    SessionStorage().setString(SsKeys.selectedPosInDetails, jsonEncode(spP.state!.toJson()));
    nav.pushNamed(RouteNames.flightDetails, pathParameters: {"flightID": f.id.toString()}).then((value) {
      DateTime current = ref.read(flightDateProvider);
      flightList(current);
    });
  }

  Future<void> editContainers(Flight f) async {
    final FlightGetContainerListResponse? res = await flightGetContainerList(f);
    // AirlineUldsController alC = getIt<AirlineUldsController>();
    // alC.airlineGetUldList();
    // final List<TagContainer>? allCons = await flightGetContainerList(f);
    if (res != null) {
      print(res.destList);
      nav.dialog(FlightContainerListDialog(flight: f, cons: res.cons, destList: res.destList));
    }
  }

  Future<FlightGetContainerListResponse?> flightGetContainerList(Flight flight) async {
    FlightGetContainerListResponse? res;
    FlightGetContainerListUseCase flightGetContainerListUsecase = FlightGetContainerListUseCase();
    FlightGetContainerListRequest flightGetContainerListRequest = FlightGetContainerListRequest(f: flight);
    final fOrR = await flightGetContainerListUsecase(request: flightGetContainerListRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetContainerList(flight)), (r) {
      res = r;
    });
    return res;
  }

  void flightAddContainer(TagContainer e) {}

  Future<List<TagContainer>> flightAddRemoveContainer(Flight flight, TagContainer c, bool isAdd, Function function, {bool isForce = false}) async {
    List<TagContainer> containers = [];
    FlightAddRemoveContainerUseCase flightAddContainerUsecase = FlightAddRemoveContainerUseCase();
    FlightAddRemoveContainerRequest flightAddRemoveContainerRequest = FlightAddRemoveContainerRequest(flight: flight, con: c, isAdd: isAdd, isForce: isForce);
    flightsState.containerAssignButtonLoading.add(c.id ?? -1);
    flightsState.setState();
    final fOrR = await flightAddContainerUsecase(request: flightAddRemoveContainerRequest);
    flightsState.containerAssignButtonLoading.remove(c.id ?? -1);
    flightsState.setState();
    fOrR.fold((f) => isAdd ? FailureHandler.customHandle(f, retry: () => flightAddRemoveContainer(flight, c, isAdd, function, isForce: true)) : FailureHandler.handle(f), (r) {
      containers = r.containers;
      function(containers);
    });
    return containers;
  }

  Future<void> pickDate() async {
    DateTime current = ref.read(flightDateProvider);
    final pickedDate = await Pickers.pickDate(nav.context, current);
    if (pickedDate != null) {
      flightList(pickedDate);
    }
  }

  void goSummary(Flight f) {
    final sfP = ref.read(selectedFlightProvider.notifier);
    sfP.state = f;
    SessionStorage().setString(SsKeys.selectedFlightP, jsonEncode(f.toJson()));
    nav.pushNamed(RouteNames.flightSummary, pathParameters: {"flightID": f.id.toString()});
  }

  Future<void> handleActions(MenuItem value, Flight flight) async {
    late final FlightsController flightsController = getIt<FlightsController>();
    switch (value) {
      case MenuItems.flightSummary:
        goSummary(flight);
        return;
      case MenuItems.assignContainer:
        await editContainers(flight);
        return;
      case MenuItems.containersPlan:
        await flightEditContainersPlanDialog(flight);
        return;
      case MenuItems.flightReport:
        await flightGetReport(flight);
        return;
      case MenuItems.reports:
        if (flightsController.isDesktop()) {
          // nav.pushNamed(RouteNames.webView);
          openWebViewWindows();
        } else {
          _launchUrl(Uri.parse(Apis.openWebView));
        }
        return;
      default:
        return;
    }
  }

  flightEditContainersPlanDialog(Flight flight) async {
    ContainersPlan? plan = await flightGetContainersPlan(flight);
    if (plan == null) return;
    var planData = plan.planData;
    for (int i = planData.length - 1; i >= 0; i--) {
      List<int> tagTypeIds = planData[i].tagTypeId;
      if (tagTypeIds.length == 1 &&
              (
                      //removing empty!
                      // (
                      BasicClass.getTagTypeByID(tagTypeIds.first)?.label ?? "")
                  .isEmpty //removing repetitive!
          // ||  (planData.any((p) => p.tagTypeId.length == 1 && p.tagTypeId.first == tagTypeIds.first && p != planData[i])))
          ) {
        planData.removeAt(i);
      }
    }
    planData.sort((a, b) => (a.planeID ?? 0).compareTo(b.planeID ?? 0));
    plan = plan.copyWith(planData: planData);
    nav.dialog(FlightContainersPlanDialog(flight: flight, plan: plan)).then((value) {});
  }

  Future<ContainersPlan?> flightGetContainersPlan(Flight flight) async {
    ContainersPlan? plan;
    FlightGetContainersPlanUseCase flightGetContainersPlanUsecase = FlightGetContainersPlanUseCase();
    FlightGetContainersPlanRequest flightGetContainersPlanRequest = FlightGetContainersPlanRequest(flight: flight);
    final fOrR = await flightGetContainersPlanUsecase(request: flightGetContainersPlanRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetContainersPlan(flight)), (r) {
      plan = r.plan;
    });
    return plan;
  }

  Future<void> flightGetPlanFile({required Flight flight, required List<int> tagTypeIds}) async {
    void da;
    FlightGetPlanFileUseCase flightGetPlanFileUsecase = FlightGetPlanFileUseCase();
    FlightGetPlanFileRequest flightGetPlanFileRequest = FlightGetPlanFileRequest(flightID: flight.id, typeIDs: tagTypeIds);
    final fOrR = await flightGetPlanFileUsecase(request: flightGetPlanFileRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetPlanFile(flight: flight, tagTypeIds: tagTypeIds)), (r) {
      final bytes = base64Decode(r.data);
      String s = "";
      for (var t in tagTypeIds) {
        TagType? type = BasicClass.getTagTypeByID(t);
        s = "$s ${type?.label ?? ""}";
      }
      nav.dialog(PDFPreviewDialog(
        pdfFileBytes: bytes,
        con: null,
        pdfURL: null,
        name: "Plan $s}",
      ));
    });
    return da;
  }

  Future<FlightReport?> flightGetReport(Flight flight) async {
    FlightReport? report;
    FlightGetReportUseCase flightGetReportUsecase = FlightGetReportUseCase();
    FlightGetReportRequest flightGetReportRequest = FlightGetReportRequest(flightID: flight.id);
    final fOrR = await flightGetReportUsecase(request: flightGetReportRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetReport(flight)), (r) {
      report = r.report;
      print("Report ${r.report.reportText}");
      nav.dialog(FlightReportDialog(flightReport: r.report, flight: flight));
    });
    return report;
  }

  Future<void> flightSendReport({required String email, required String typeB, required Flight flight, required bool attachment}) async {
    // if (email.trim().isEmpty && typeB.trim().isEmpty) {
    //   FailureHandler.handle(ValidationFailure(code: 1, msg: "Both the email address and type-b can not be empty", traceMsg: ""));
    //   return;
    // }

    if (email.trim().isNotEmpty) {
      List<String> invalidEmails =
          email.split(",").where((element) => element.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(element.trim())).toList();
      if (invalidEmails.isNotEmpty) {
        FailureHandler.handle(ValidationFailure(code: 1, msg: "${invalidEmails.join(",")} ${invalidEmails.length > 1 ? 'are' : 'is'} not a valid email address", traceMsg: ""));
        return;
      }
    }
    if (typeB.trim().isNotEmpty) {
      List<String> invalidTypeB = typeB.split(",").where((element) => element.isNotEmpty && element.trim().length != 7).toList();
      if (invalidTypeB.isNotEmpty) {
        FailureHandler.handle(ValidationFailure(code: 1, msg: "${invalidTypeB.join(",")} ${invalidTypeB.length > 1 ? 'are' : 'is'} not a valid type-b address", traceMsg: ""));
        return;
      }
    }
    FlightSendReportUseCase flightSendReportUsecase = FlightSendReportUseCase();
    FlightSendReportRequest flightSendReportRequest = FlightSendReportRequest(typeB: typeB, email: email, flight: flight, attachment: attachment);
    final fOrR = await flightSendReportUsecase(request: flightSendReportRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightSendReport(email: email, typeB: typeB, flight: flight, attachment: attachment)), (r) {
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Report Sent Successfully!"));
    });
  }

  Future<String> _getWebViewPath() async {
    final document = await getApplicationDocumentsDirectory();
    return p.join(
      document.path,
      'desktop_webview_window',
    );
  }

  void openWebViewWindows() async {
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        userDataFolderWindows: await _getWebViewPath(),
        titleBarTopPadding: Platform.isMacOS ? 20 : 0,
      ),
    );
    webview
      // ..setBrightness(Brightness.dark)
      ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
      ..launch(Apis.openWebView)
      ..addOnUrlRequestCallback((url) {
        // debugPrint('url: $url');
        final uri = Uri.parse(url);
        if (uri.path == '/login_success') {
          // debugPrint('login success. token: ${uri.queryParameters['token']}');
          webview.close();
        }
      })
      ..onClose.whenComplete(() {
        // debugPrint("on close");
      });
    await Future.delayed(const Duration(seconds: 2));
  }

  bool isDesktop() {
    DeviceInfoService deviceInfoService = getIt<DeviceInfoService>();
    DeviceInfo deviceInfo = deviceInfoService.getInfo();
    return deviceInfo.screenType == ScreenType.desktop;
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  // savePlans({required Flight flight, required ContainersPlan newPlan}) {}

  Future<ContainersPlan?> flightSavePlans({required Flight flight, required ContainersPlan newPlan, required int? sectionID, required int? spotID}) async {
    ContainersPlan? plans;
    FlightSaveContainersPlanUseCase flightSavePlansUsecase = FlightSaveContainersPlanUseCase();
    FlightSaveContainersPlanRequest flightSaveContainersPlanRequest = FlightSaveContainersPlanRequest(f: flight, plan: newPlan, secID: sectionID, spotID: spotID);
    final fOrR = await flightSavePlansUsecase(request: flightSaveContainersPlanRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightSavePlans(flight: flight, newPlan: newPlan, sectionID: sectionID, spotID: spotID)), (r) {
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Plan Saved Successfully!"));
    });

    return plans;
  }
}
