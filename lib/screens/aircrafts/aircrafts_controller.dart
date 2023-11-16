import '../../core/abstracts/controller_abs.dart';
import '../../core/navigation/route_names.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'aircrafts_state.dart';

class AircraftsController extends MainController {
  late AircraftsState aircraftsState = ref.read(aircraftsProvider);
  // UseCase UseCase = UseCase(repository: Repository());

  void goAddAircraft() {
    nav.pushNamed(RouteNames.addFlight);
  }
}
