import 'package:brs_panel/core/navigation/route_names.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

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

  void goDetails(Flight f) {
    final sfP = ref.read(selectedFlightProvider.notifier);
    sfP.state = f;
    nav.pushNamed(RouteNames.flightDetails, pathParameters: {"flightID": f.id.toString()});
  }
}
