import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'airline_ulds_state.dart';

class AirlineUldsController extends MainController {
  late AirlineUldsState airline_uldsState = ref.read(airline_uldsProvider);
  // UseCase UseCase = UseCase(repository: Repository());

}
