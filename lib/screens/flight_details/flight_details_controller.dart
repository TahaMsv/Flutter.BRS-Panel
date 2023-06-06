import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'flight_details_state.dart';

class FlightDetailsController extends MainController {
  late FlightDetailsState flight_detailsState = ref.read(flight_detailsProvider);
  // UseCase UseCase = UseCase(repository: Repository());

}
