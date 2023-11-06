import 'package:brs_panel/core/classes/flight_summary_class.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/screens/flight_summary/dialogs/flight_history_log_dialog.dart';
import 'package:brs_panel/screens/flight_summary/usecases/flight_get_history_log_usecase.dart';
import 'package:brs_panel/screens/flight_summary/usecases/flight_get_summary_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/history_log_class.dart';
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
    if (flight == null) return;
    HistoryLog? log = await flightGetHistoryLog(flight);
    if (log == null) return;
    nav.dialog(FlightHistoryLogDialog(logs: log));
  }

  Future<HistoryLog?> flightGetHistoryLog(Flight flight) async {
    HistoryLog? log;
    FlightGetHistoryLogUseCase flightGetHistoryLogUsecase = FlightGetHistoryLogUseCase();
    FlightGetHistoryLogRequest flightGetHistoryLogRequest = FlightGetHistoryLogRequest(airport: null, flightID: flight.id, tagID: null, userID: null);
    final fOrR = await flightGetHistoryLogUsecase(request:flightGetHistoryLogRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetHistoryLog(flight)), (r) {
      log = r.logs;
    });
    return log;
  }

}
