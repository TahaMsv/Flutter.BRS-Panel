import 'package:brs_panel/core/classes/login_user_class.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airline_add_uld_usecase.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airline_delete_uld_usecase.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airline_update_uld_usecase.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airport_get_carts_usecase.dart';

import '../../core/abstracts/controller_abs.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/airport_cart_class.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/confirm_operation.dart';
import '../../core/util/handlers/failure_handler.dart';

import '../../core/util/handlers/success_handler.dart';
import 'airport_carts_state.dart';
import 'dialogs/add_update_airport_cart_dailog.dart';

class AirportCartsController extends MainController {
  late AirportCartsState airportCartsState = ref.read(airportCartsProvider);

  Future<List<TagContainer>?> airportGetCarts() async {
    Airport? sapP = ref.read(selectedAirportProvider);
    if(sapP==null) return null;
    List<TagContainer>? carts;
    AirportGetCartsUseCase airportGetCartsUsecase = AirportGetCartsUseCase();
    AirportGetCartsRequest airportGetCartsRequest = AirportGetCartsRequest(airport: sapP);
    final fOrR = await airportGetCartsUsecase(request: airportGetCartsRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportGetCarts()), (r) {
      carts = r.airportCarts;
      final cartsP = ref.watch(cartListProvider.notifier);
      cartsP.setAirportCarts(r.airportCarts);
    });
    return carts;
  }

  Future<TagContainer?> airportAddCart(String cartCode) async {
    Airport? sapP = ref.read(selectedAirportProvider);
    TagContainer? cart;
    AirportAddCartUseCase airportAddCartUsecase = AirportAddCartUseCase();
    AirportAddCartRequest airportAddCartRequest = AirportAddCartRequest(airport: sapP!.code, cartCode: cartCode);
    final fOrR = await airportAddCartUsecase(request: airportAddCartRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportAddCart(cartCode)), (r) {
      cart = r.cart;
      final cartListP = ref.read(cartListProvider.notifier);
      cartListP.addAirportCart(r.cart);
    });
    return cart;
  }

  Future<TagContainer?> airportUpdateCart(TagContainer updating) async {
    Airport? sapP = ref.read(selectedAirportProvider);
    TagContainer? cart;
    AirportUpdateCartUseCase airportUpdateCartUsecase = AirportUpdateCartUseCase();
    AirportUpdateCartRequest airportUpdateCartRequest = AirportUpdateCartRequest(
      id: updating.id!,
      airport: sapP!.code,
      cartCode: updating.code,
    );
    final fOrR = await airportUpdateCartUsecase(request: airportUpdateCartRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportUpdateCart(updating)), (r) {
      cart = r.cart;
      final cartListP = ref.read(cartListProvider.notifier);
      cartListP.updateCart(r.cart);
    });
    return cart;
  }

  Future<bool> airportDeleteCart(TagContainer cart) async {
    Airport? sapP = ref.read(selectedAirportProvider);
    bool status = false;
    AirportDeleteCartUseCase airportDeleteCartUsecase = AirportDeleteCartUseCase();
    AirportDeleteCartRequest airportDeleteCartRequest = AirportDeleteCartRequest(id: cart.id!, airport: sapP!.code);
    final fOrR = await airportDeleteCartUsecase(request: airportDeleteCartRequest);

    fOrR.fold((f) => FailureHandler.handle(f, retry: () => airportDeleteCart(cart)), (r) {
      status = r.isSuccess;
      final cartListP = ref.read(cartListProvider.notifier);
      cartListP.removeAirportCart(cart.id!);
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Cart Deleted Successfully"));
    });
    return status;
  }

  void addCart() {
    nav.dialog(const AddUpdateAirportCartDialog(editingCart: null));
  }

  void updateCart(TagContainer cart) {
    nav.dialog(AddUpdateAirportCartDialog(editingCart: cart));
  }

  Future<void> deleteCart(TagContainer cart) async {
    bool confirm = await ConfirmOperation.getConfirm(Operation(message: "You are Deleting Cart ${cart.code}", title: "Are You Sure", actions: ["Cancel","Confirm"],type: OperationType.warning));
    if(confirm){
      airportDeleteCart(cart);
    }
  }
}
