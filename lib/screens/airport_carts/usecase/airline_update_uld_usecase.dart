import 'package:brs_panel/core/classes/airport_cart_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/user_class.dart';
import '../airport_carts_repository.dart';

class AirportUpdateCartUseCase extends UseCase<AirportUpdateCartResponse,AirportUpdateCartRequest> {
  AirportUpdateCartUseCase();

  @override
  Future<Either<Failure, AirportUpdateCartResponse>> call({required AirportUpdateCartRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AirportCartsRepository repository = AirportCartsRepository();
    return repository.airportUpdateCart(request);
  }

}

class AirportUpdateCartRequest extends Request {
  final int id;
  final String airport;
  final String cartCode;
  AirportUpdateCartRequest({
    required this.id,
    required this.airport,
    required this.cartCode,
});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "UpdateCart",
      "Token":token,
      "Request": {
        "ID":id,
        "Airport": airport,
        "Code": cartCode,
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class AirportUpdateCartResponse extends Response {
  final TagContainer cart;
  AirportUpdateCartResponse({required int status, required String message, required this.cart})
      : super(
          status: status,
          message: message,
          body:  [cart.toJson()],
        );

    factory AirportUpdateCartResponse.fromResponse(Response res) => AirportUpdateCartResponse(
        status: res.status,
        message: res.message,
        cart:TagContainer.fromJson(res.body),
      );

}

