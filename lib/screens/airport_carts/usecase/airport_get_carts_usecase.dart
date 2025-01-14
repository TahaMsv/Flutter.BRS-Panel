import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/tag_container_class.dart';
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
  final String airportCode;
  AirportGetCartsRequest({required this.airportCode});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "CartList",
      "Token":token,
      "Request": {
        "Airport": airportCode
      }
    }
  };

  Failure? validate(){
    return null;
  }
}

class AirportGetCartsResponse extends Response {
  final List<TagContainer> airportCarts;

  AirportGetCartsResponse({required int status, required String message, required this.airportCarts})
      : super(status: status, message: message, body:airportCarts.map((e)=>e.toJson()).toList());

  factory AirportGetCartsResponse.fromResponse(Response res) => AirportGetCartsResponse(
        status: res.status,
        message: res.message,
        airportCarts: List<TagContainer>.from(res.body.map((x) => TagContainer.fromJson(x))),
      );
}
