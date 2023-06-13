import 'package:brs_panel/core/navigation/route_names.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/airline_ulds/airline_ulds_controller.dart';
import 'package:brs_panel/screens/airlines/airlines_controller.dart';
import 'package:brs_panel/screens/flight_details/flight_details_state.dart';
import 'package:brs_panel/screens/flights/dialogs/flight_container_list_dialog.dart';
import 'package:brs_panel/screens/flights/usecases/flight_add_remove_container_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_get_container_list_usecase.dart';
import 'package:brs_panel/screens/flights/usecases/flight_list_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_class.dart';
import '../../core/classes/flight_details_class.dart';
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
    final spP = ref.read(selectedPosInDetails.notifier);
    spP.state = BasicClass.getPositionByID(f.positions.first.id)!;
    nav.pushNamed(RouteNames.flightDetails, pathParameters: {"flightID": f.id.toString()});
  }

  Future<void> editContainers(Flight f) async {
    final List<TagContainer>? cons = await flightGetContainerList(f);
    // AirlineUldsController alC = getIt<AirlineUldsController>();
    // alC.airlineGetUldList();
    // final List<TagContainer>? allCons = await flightGetContainerList(f);
    if (cons != null) {

      nav.dialog(FlightContainerListDialog(flight: f,cons: cons));
    }
  }

  Future<List<TagContainer>?> flightGetContainerList(Flight flight) async {
    List<TagContainer>? cons;
    FlightGetContainerListUseCase flightGetContainerListUsecase = FlightGetContainerListUseCase();
    FlightGetContainerListRequest flightGetContainerListRequest = FlightGetContainerListRequest(f: flight);
    final fOrR = await flightGetContainerListUsecase(request: flightGetContainerListRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetContainerList(flight)), (r) {
      cons = r.cons;
    });
    return cons;
  }

  void flightAddContainer(TagContainer e) {}

  Future<TagContainer?> flightAddRemoveContainer(Flight flight,TagContainer c, bool isAdd) async {
    TagContainer? container;
    FlightAddRemoveContainerUseCase flightAddContainerUsecase = FlightAddRemoveContainerUseCase();
    FlightAddRemoveContainerRequest flightAddRemoveContainerRequest = FlightAddRemoveContainerRequest(
      flight:flight,
      con: c,
      isAdd: isAdd,
    );
    final fOrR = await flightAddContainerUsecase(request: flightAddRemoveContainerRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightAddRemoveContainer(flight,c, isAdd)), (r) {
      container = r.container;
    });
    return container;
  }
}
