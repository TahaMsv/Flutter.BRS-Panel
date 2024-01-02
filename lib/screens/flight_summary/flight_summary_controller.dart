import 'dart:convert';

import 'package:brs_panel/core/classes/flight_summary_class.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/screens/flight_summary/dialogs/flight_history_log_dialog.dart';
import 'package:brs_panel/screens/flight_summary/usecases/flight_get_history_log_usecase.dart';
import 'package:brs_panel/screens/flight_summary/usecases/flight_get_summary_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/history_log_class.dart';
import '../../core/constants/data_bases_keys.dart';
import '../../core/data_base/web_data_base.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'flight_summary_state.dart';

class FlightSummaryController extends MainController {
  late FlightSummaryState flightSummaryState = ref.read(flightSummaryStateProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  Future<FlightSummary?> flightGetSummary(int flightID) async {
    // final fdP = ref.read(detailsProvider.notifier);
    FlightSummary? flightSummary;
    FlightGetSummaryUseCase flightGetSummaryUseCase = FlightGetSummaryUseCase();
    FlightGetSummaryRequest flightGetSummaryRequest = FlightGetSummaryRequest(flightID: flightID);
    final fOrR = await flightGetSummaryUseCase(request: flightGetSummaryRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetSummary(flightID)), (r) {
      flightSummary = r.summary;
      // final fdP = ref.read(detailsProvider.notifier);
      // fdP.setFlightDetails(r.details);
    });
    return flightSummary;
  }

  Future<void> flightShowHistoryLogs() async {
    Flight? flight = ref.read(selectedFlightProvider);
    print("Here40");
    if (flight == null) return;
    print("Here41");
    HistoryLog? log = await flightGetHistoryLog(flight);
    print("Here43");
    if (log == null) return;
    print("Here44");
    nav.dialog(FlightHistoryLogDialog(logs: log));
  }

  Future<HistoryLog?> flightGetHistoryLog(Flight flight) async {
    HistoryLog? log;

    FlightGetHistoryLogUseCase flightGetHistoryLogUsecase = FlightGetHistoryLogUseCase();

    FlightGetHistoryLogRequest flightGetHistoryLogRequest = FlightGetHistoryLogRequest(airport: null, flightID: flight.id, tagID: null, userID: null);
    final fOrR = await flightGetHistoryLogUsecase(request: flightGetHistoryLogRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetHistoryLog(flight)), (r) {
      log = r.logs;
    });
    return log;
  }

  Future<void> retrieveFlightSummaryScreenFromLocalStorage() async {
    String? selectedFlightPString = await SessionStorage().getString(SsKeys.selectedFlightP);

    final sfP = ref.read(selectedFlightProvider.notifier);
    sfP.state = Flight.fromJson(jsonDecode(selectedFlightPString!));
  }
}
