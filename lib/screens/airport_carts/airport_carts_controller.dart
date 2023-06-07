import 'package:brs_panel/core/classes/user_class.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airport_get_carts_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/airport_cart_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'airport_carts_state.dart';

class AirportCartsController extends MainController {
  late AirportCartsState airportCartsState = ref.read(airportCartsProvider);

  void addCart() {}


  Future<List<AirportCart>?> airportGetCarts(Airport airport) async {
    List<AirportCart>? carts;
    AirportGetCartsUseCase airportGetCartsUsecase = AirportGetCartsUseCase();
    AirportGetCartsRequest airportGetCartsRequest = AirportGetCartsRequest(airport: airport);
    final fOrR = await airportGetCartsUsecase(request: airportGetCartsRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportGetCarts(airport)), (r) {
      carts = r.airportCarts;
      final cartsP = ref.watch(cartListProvider.notifier);
      print(carts!.length);
      cartsP.setAirportCarts(r.airportCarts);

    });
    return carts;
  }
}
