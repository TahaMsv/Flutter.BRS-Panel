import 'package:brs_panel/core/classes/airport_cart_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../airport_carts_repository.dart';

class AirportGetCartsUseCase extends UseCase<AirportGetCartsResponse,AirportGetCartsRequest> {
  AirportGetCartsUseCase();

  @override
  Future<Either<Failure, AirportGetCartsResponse>> call({required AirportGetCartsRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AirportCartsRepository repository = AirportCartsRepository();
    return repository.airportGetCarts(request);
  }

}

class AirportGetCartsRequest extends Request {
  final Airport airport;
  AirportGetCartsRequest({required this.airport});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "CartList",
      "Token":token,
      "Request": {
        "Airport": airport.code
      }
    }
  };

  Failure? validate(){
    return null;
  }
}

class AirportGetCartsResponse extends Response {
  final List<AirportCart> airportCarts;

  AirportGetCartsResponse({required int status, required String message, required this.airportCarts})
      : super(status: status, message: message, body:airportCarts.map((e)=>e.toJson()).toList());

  factory AirportGetCartsResponse.fromResponse(Response res) => AirportGetCartsResponse(
        status: res.status,
        message: res.message,
        airportCarts: List<AirportCart>.from(res.body.map((x) => AirportCart.fromJson(x))),
      );
}
