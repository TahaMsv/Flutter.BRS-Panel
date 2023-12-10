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
    flightList(DateTime.now());
  }

  Future<List<Flight>?> flightList(DateTime dt) async {
    final flightDateP = ref.read(flightDateProvider.notifier);
    flightDateP.state = dt;
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

  void goAddFlight() {
    nav.pushNamed(RouteNames.addFlight);
  }

  void goDetails(Flight f, {Position? selectedPos}) {
    final sfP = ref.read(selectedFlightProvider.notifier);
    sfP.state = f;
    final spP = ref.read(selectedPosInDetails.notifier);
    spP.state = BasicClass.getPositionByID(selectedPos?.id ?? f.positions.first.id)!;
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

  Future<TagContainer?> flightAddRemoveContainer(Flight flight, TagContainer c, bool isAdd) async {
    TagContainer? container;
    FlightAddRemoveContainerUseCase flightAddContainerUsecase = FlightAddRemoveContainerUseCase();
    FlightAddRemoveContainerRequest flightAddRemoveContainerRequest = FlightAddRemoveContainerRequest(
      flight: flight,
      con: c,
      isAdd: isAdd,
    );
    final fOrR = await flightAddContainerUsecase(request: flightAddRemoveContainerRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightAddRemoveContainer(flight, c, isAdd)), (r) {
      container = r.container;
    });
    return container;
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

  Future<void> flightGetPlanFile({required Flight flight, required TagType type}) async {
    void da;
    FlightGetPlanFileUseCase flightGetPlanFileUsecase = FlightGetPlanFileUseCase();
    FlightGetPlanFileRequest flightGetPlanFileRequest = FlightGetPlanFileRequest(flightID: flight.id, typeID: type.id);
    final fOrR = await flightGetPlanFileUsecase(request: flightGetPlanFileRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetPlanFile(flight: flight, type: type)), (r) {
      final bytes = base64Decode(r.data);
      nav.dialog(PDFPreviewDialog(
        pdfFileBytes: bytes,
        con: null,
        pdfURL: null,
        name: "Plan ${type.label}",
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

  Future<void> flightSendReport(
      {required String email, required String typeB, required Flight flight, required bool attachment}) async {
    if (email.trim().isNotEmpty) {
      List<String> invalidEmails = email
          .split(",")
          .where((element) =>
              element.isNotEmpty &&
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(element.trim()))
          .toList();
      if (invalidEmails.isNotEmpty) {
        FailureHandler.handle(ValidationFailure(
            code: 1,
            msg: "${invalidEmails.join(",")} ${invalidEmails.length > 1 ? 'are' : 'is'} not a valid email address",
            traceMsg: ""));
        return;
      }
    }
    if (typeB.trim().isNotEmpty) {
      List<String> invalidTypeB =
          typeB.split(",").where((element) => element.isNotEmpty && element.trim().length != 7).toList();
      if (invalidTypeB.isNotEmpty) {
        FailureHandler.handle(ValidationFailure(
            code: 1,
            msg: "${invalidTypeB.join(",")} ${invalidTypeB.length > 1 ? 'are' : 'is'} not a valid type-b address",
            traceMsg: ""));
        return;
      }
    }
    FlightSendReportUseCase flightSendReportUsecase = FlightSendReportUseCase();
    FlightSendReportRequest flightSendReportRequest =
        FlightSendReportRequest(typeB: typeB, email: email, flight: flight, attachment: attachment);
    final fOrR = await flightSendReportUsecase(request: flightSendReportRequest);

    fOrR.fold(
        (f) => FailureHandler.handle(f,
            retry: () => flightSendReport(email: email, typeB: typeB, flight: flight, attachment: attachment)), (r) {
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
      ..launch('https://pub.dev')
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

  savePlans({required Flight flight, required ContainersPlan newPlan}) {}

  Future<ContainersPlan?> flightSavePlans({required Flight flight, required ContainersPlan newPlan}) async {
    ContainersPlan? plans;
    FlightSaveContainersPlanUseCase flightSavePlansUsecase = FlightSaveContainersPlanUseCase();
    FlightSaveContainersPlanRequest flightSaveContainersPlanRequest =
        FlightSaveContainersPlanRequest(flight: flight, plan: newPlan);
    final fOrR = await flightSavePlansUsecase(request: flightSaveContainersPlanRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightSavePlans(flight: flight, newPlan: newPlan)), (r) {
      // plans = r.plan;
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Plan Saved Successfully!"));
    });

    return plans;
  }
}
