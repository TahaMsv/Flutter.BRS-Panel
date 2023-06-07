import 'package:brs_panel/core/classes/user_class.dart';
import 'package:brs_panel/core/navigation/route_names.dart';
import 'package:brs_panel/initialize.dart';
import 'package:brs_panel/screens/airline_ulds/airline_ulds_controller.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'airlines_state.dart';

class AirlinesController extends MainController {
  late AirlinesState airlinesState = ref.read(airlinesProvider);

  Future<void> goUlds(Airline al) async{
    AirlineUldsController airlineUldsController = getIt<AirlineUldsController>();
    final ulds = await airlineUldsController.airlineGetUldList(al);
    if(ulds!=null) {
      nav.pushNamed(RouteNames.airlineUlds);
    }
  }
  // UseCase UseCase = UseCase(repository: Repository());

}
