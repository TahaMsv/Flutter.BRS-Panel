import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/util/pickers.dart';
import 'package:brs_panel/screens/add_flight/usecases/add_flight_usecase.dart';
import 'package:flutter/material.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/flight_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import '../../core/util/handlers/success_handler.dart';
import '../flights/flights_state.dart';
import 'add_flight_state.dart';

class AddFlightController extends MainController {
  late AddFlightState addFlightState = ref.read(addFlightProvider);

  @override
  onInit() {
    print("onInit");
    addFlightState.clear();
    addFlightState.setState();
    super.onInit();
  }

  Future<Flight?> addFlight() async {
    Flight? flight;
    AddFlightUseCase addFlightUsecase = AddFlightUseCase();
    AddFlightRequest addFlightRequest = addFlightState.createAddFlightRequest();
    final fOrR = await addFlightUsecase(request: addFlightRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => addFlight()), (r) {
      if (r.flights.isNotEmpty) {
        flight = r.flights.first;
        final flightList = ref.read(flightListProvider.notifier);
        if (ref.read(flightDateProvider).format_yyyyMMdd == flight!.flightDate.format_yyyyMMdd) {
          flightList.addFlight(flight!);
        }
      }
      nav.goBack(result: r, onPop: () => SuccessHandler.handle(ServerSuccess(code: 1, msg: "Done\nFlight Added Successfully")));
    });
    return flight;
  }

  setFromDate(int? i) async {
    if (i != null) {
      addFlightState.fromDate = addFlightState.fromDate.add(Duration(days: i));
    } else {
      final newDate = await Pickers.pickDate(nav.context, addFlightState.fromDate);
      if (newDate == null) return;
      addFlightState.fromDate = newDate;
    }
    addFlightState.setState();
  }

  setToDate(int? i) async {
    if (i != null) {
      addFlightState.toDate = addFlightState.toDate.add(Duration(days: i));
    } else {
      final newDate = await Pickers.pickDate(nav.context, addFlightState.toDate ?? DateTime.now());
      if (newDate == null) return;
      addFlightState.toDate = newDate;
    }
    addFlightState.setState();
  }

  // UseCase UseCase = UseCase(repository: Repository());

  void setSTD() {
    Pickers.pickTime(nav.context, addFlightState.std ?? TimeOfDay.now()).then((value) {
      if (value != null) {
        addFlightState.std = value;
        addFlightState.setState();
      }
    });
  }

  void setSTA() {
    Pickers.pickTime(nav.context, addFlightState.sta ?? TimeOfDay.now()).then((value) {
      if (value != null) {
        addFlightState.sta = value;
        addFlightState.setState();
      }
    });
  }

  void setDayStd(int dayId) {
    // TimeOfDay time = TimeOfDay.
    Pickers.pickTime(nav.context, addFlightState.weekTimes[dayId]?[0] ?? TimeOfDay.now()).then((value) {
      if (value != null) {
        addFlightState.weekTimes["$dayId"]![0] = value;
        addFlightState.weekTimes["$dayId"]![1] = value.add(const Duration(hours: 1, minutes: 30));
        addFlightState.setState();
      }
    });
  }

  void setDaySta(int dayId) {
    // TimeOfDay time = TimeOfDay.
    Pickers.pickTime(nav.context, addFlightState.weekTimes[dayId]?[1] ?? TimeOfDay.now()).then((value) {
      if (value != null) {
        addFlightState.weekTimes["$dayId"]![1] = value;
        addFlightState.setState();
      }
    });
  }
}
