import 'package:brs_panel/core/classes/airline_uld_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/user_class.dart';
import '../airline_ulds_repository.dart';

class AirlineUpdateUldUseCase extends UseCase<AirlineUpdateUldResponse,AirlineUpdateUldRequest> {
  AirlineUpdateUldUseCase();

  @override
  Future<Either<Failure, AirlineUpdateUldResponse>> call({required AirlineUpdateUldRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AirlineUldsRepository repository = AirlineUldsRepository();
    return repository.airlineUpdateUld(request);
  }

}

class AirlineUpdateUldRequest extends Request {
  final int id;
  final String al;
  final String uldCode;
  final int uldType;
  AirlineUpdateUldRequest({
    required this.id,
    required this.al,
    required this.uldCode,
    required this.uldType,
});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "UpdateULD",
      "Token":token,
      "Request": {
        "ID":id,
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


class AirlineUpdateUldResponse extends Response {
  final TagContainer uld;
  AirlineUpdateUldResponse({required int status, required String message, required this.uld})
      : super(
          status: status,
          message: message,
          body:  [uld.toJson()],
        );

    factory AirlineUpdateUldResponse.fromResponse(Response res) => AirlineUpdateUldResponse(
        status: res.status,
        message: res.message,
        uld:TagContainer.fromJson(res.body),
      );

}

