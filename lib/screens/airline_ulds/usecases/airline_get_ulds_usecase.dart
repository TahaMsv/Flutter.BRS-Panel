import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airline_uld_class.dart';
import '../../../core/classes/user_class.dart';
import '../airline_ulds_repository.dart';

class AirlineGetUldListUseCase extends UseCase<AirlineGetUldListResponse,AirlineGetUldListRequest> {
  AirlineGetUldListUseCase();

  @override
  Future<Either<Failure, AirlineGetUldListResponse>> call({required AirlineGetUldListRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    AirlineUldsRepository repository = AirlineUldsRepository();
    return repository.airlineGetUldList(request);
  }

}

class AirlineGetUldListRequest extends Request {
  final Airline al;
  AirlineGetUldListRequest({required this.al});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "ULDList",
      "Token":token,
      "Request": {
        "AL": al.al
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class AirlineGetUldListResponse extends Response {
  final List<AirlineUld> ulds;

  AirlineGetUldListResponse({required int status, required String message, required this.ulds})
      : super(status: status, message: message, body:ulds.map((e)=>e.toJson()).toList());

  factory AirlineGetUldListResponse.fromResponse(Response res) => AirlineGetUldListResponse(
        status: res.status,
        message: res.message,
        ulds: List<AirlineUld>.from(res.body.map((x) => AirlineUld.fromJson(x))),
      );
}
