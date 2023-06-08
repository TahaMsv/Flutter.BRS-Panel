import 'package:brs_panel/screens/flight_details/usecases/flight_get_details_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'flight_details_state.dart';

class FlightDetailsController extends MainController {
  late FlightDetailsState flightDetailsState = ref.read(flightDetailsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  Future<FlightDetails?> flightGetDetails(int flightID) async {
    // final fdP = ref.read(detailsProvider.notifier);
    FlightDetails? flightDetails;
    FlightGetDetailsUseCase flightGetDetailsUsecase = FlightGetDetailsUseCase();
    FlightGetDetailsRequest flightGetDetailsRequest = FlightGetDetailsRequest(flightID: flightID);
    final fOrR = await flightGetDetailsUsecase(request: flightGetDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetDetails(flightID)), (r) {
      flightDetails = r.details;
      // final fdP = ref.read(detailsProvider.notifier);
      // fdP.setFlightDetails(r.details);
    });
    return flightDetails;
  }

}
