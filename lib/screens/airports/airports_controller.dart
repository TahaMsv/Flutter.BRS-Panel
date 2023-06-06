import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'airports_state.dart';

class AirportsController extends MainController {
  late AirportsState airportsState = ref.read(airportsProvider);
  // UseCase UseCase = UseCase(repository: Repository());

}
