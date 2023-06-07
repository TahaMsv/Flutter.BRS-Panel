import 'package:brs_panel/core/classes/user_class.dart';
import 'package:brs_panel/core/navigation/route_names.dart';
import 'package:flutter/cupertino.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import '../../initialize.dart';
import '../airport_carts/airport_carts_controller.dart';
import 'airports_state.dart';

class AirportsController extends MainController {
  late AirportsState airportsState = ref.read(airportsProvider);

  // UseCase UseCase = UseCase(repository: Repository());

  Future<void> goCarts(Airport a) async {
    AirportCartsController airportCartsController = getIt<AirportCartsController>();
    final ulds = await airportCartsController.airportGetCarts(a);
    if (ulds != null) {
      nav.pushNamed(RouteNames.airportCarts);
    }
  }
}
