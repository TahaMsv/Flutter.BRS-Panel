import 'package:brs_panel/core/classes/airport_cart_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../airport_carts_repository.dart';

class AirportDeleteCartUseCase extends UseCase<AirportDeleteCartResponse, AirportDeleteCartRequest> {
  AirportDeleteCartUseCase();

  @override
  Future<Either<Failure, AirportDeleteCartResponse>> call({required AirportDeleteCartRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportCartsRepository repository = AirportCartsRepository();
    return repository.airportDeleteCart(request);
  }
}

class AirportDeleteCartRequest extends Request {
  final int id;
  final String airport;

  AirportDeleteCartRequest({
    required this.id,
    required this.airport,
  });

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "DeleteCart",
          "Token": token,
          "Request": {
            "ID": id,
            "Airport": airport,
          }
        }
      };

  Failure? validate() {
    return null;
  }
}

class AirportDeleteCartResponse extends Response {
  AirportDeleteCartResponse({required int status, required String message})
      : super(
          status: status,
          message: message,
          body: null,
        );

  factory AirportDeleteCartResponse.fromResponse(Response res) => AirportDeleteCartResponse(
        status: res.status,
        message: res.message,
      );
}
