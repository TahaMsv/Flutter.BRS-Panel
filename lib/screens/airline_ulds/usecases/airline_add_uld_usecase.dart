import 'package:brs_panel/core/classes/airline_uld_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../airline_ulds_repository.dart';

class AirlineAddUldUseCase extends UseCase<AirlineAddUldResponse,AirlineAddUldRequest> {
  AirlineAddUldUseCase();

  @override
  Future<Either<Failure, AirlineAddUldResponse>> call({required AirlineAddUldRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AirlineUldsRepository repository = AirlineUldsRepository();
    return repository.airlineAddUld(request);
  }

}

class AirlineAddUldRequest extends Request {
  final String al;
  final String uldCode;
  final String uldType;
  AirlineAddUldRequest({
    required this.al,
    required this.uldCode,
    required this.uldType,
});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "AddULD",
      "Token":token,
      "Request": {
        "AL": al,
        "Code": uldCode,
        "ULDType": uldType
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class AirlineAddUldResponse extends Response {
  final TagContainer uld;
  AirlineAddUldResponse({required int status, required String message, required this.uld})
      : super(
          status: status,
          message: message,
          body:  uld.toJson(),
        );

    factory AirlineAddUldResponse.fromResponse(Response res) => AirlineAddUldResponse(
        status: res.status,
        message: res.message,
        uld:TagContainer.fromJson(res.body),
      );

}

