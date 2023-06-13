import 'package:brs_panel/core/classes/airport_cart_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/user_class.dart';
import '../airport_carts_repository.dart';

class AirportAddCartUseCase extends UseCase<AirportAddCartResponse,AirportAddCartRequest> {
  AirportAddCartUseCase();

  @override
  Future<Either<Failure, AirportAddCartResponse>> call({required AirportAddCartRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AirportCartsRepository repository = AirportCartsRepository();
    return repository.airportAddCart(request);
  }

}

class AirportAddCartRequest extends Request {
  final String airport;
  final String cartCode;
  // final String cartType;
  AirportAddCartRequest({
    required this.airport,
    required this.cartCode,
    // required this.cartType,
});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "AddCart",
      "Token":token,
      "Request": {
        "Airport": airport,
        "Code": cartCode,
        // "ULDType": cartType
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class AirportAddCartResponse extends Response {
  final TagContainer cart;
  AirportAddCartResponse({required int status, required String message, required this.cart})
      : super(
          status: status,
          message: message,
          body:  cart.toJson(),
        );

    factory AirportAddCartResponse.fromResponse(Response res) => AirportAddCartResponse(
        status: res.status,
        message: res.message,
        cart:TagContainer.fromJson(res.body),
      );

}

