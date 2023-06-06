import 'package:brs_panel/core/classes/user_class.dart';
import 'package:brs_panel/core/navigation/route_names.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'airlines_state.dart';

class AirlinesController extends MainController {
  late AirlinesState airlinesState = ref.read(airlinesProvider);

  void goUlds(Airline f) {
    nav.pushNamed(RouteNames.airlineUlds);
  }
  // UseCase UseCase = UseCase(repository: Repository());

}
