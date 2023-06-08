import 'package:brs_panel/core/classes/airline_uld_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../airline_ulds_repository.dart';

class AirlineDeleteUldUseCase extends UseCase<AirlineDeleteUldResponse, AirlineDeleteUldRequest> {
  AirlineDeleteUldUseCase();

  @override
  Future<Either<Failure, AirlineDeleteUldResponse>> call({required AirlineDeleteUldRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirlineUldsRepository repository = AirlineUldsRepository();
    return repository.airlineDeleteUld(request);
  }
}

class AirlineDeleteUldRequest extends Request {
  final int id;
  final String al;

  AirlineDeleteUldRequest({
    required this.id,
    required this.al,
  });

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "DeleteULD",
          "Token": token,
          "Request": {
            "ID": id,
            "AL": al,
          }
        }
      };

  Failure? validate() {
    return null;
  }
}

class AirlineDeleteUldResponse extends Response {
  AirlineDeleteUldResponse({required int status, required String message})
      : super(
          status: status,
          message: message,
          body: null,
        );

  factory AirlineDeleteUldResponse.fromResponse(Response res) => AirlineDeleteUldResponse(
        status: res.status,
        message: res.message,
      );
}
