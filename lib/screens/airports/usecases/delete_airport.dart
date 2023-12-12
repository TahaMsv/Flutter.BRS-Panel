import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../airports_repository.dart';

class DeleteAirportUseCase extends UseCase<DeleteAirportResponse, DeleteAirportRequest> {
  DeleteAirportUseCase();

  @override
  Future<Either<Failure, DeleteAirportResponse>> call({required DeleteAirportRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportsRepository repository = AirportsRepository();
    return repository.deleteAirport(request);
  }
}

class DeleteAirportRequest extends Request {
  DeleteAirportRequest({required this.code});

  final String code;

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "DeleteAirport",
          "Request": {"Code": code}
        }
      };

  Failure? validate() {
    return null;
  }
}

class DeleteAirportResponse extends Response {
  DeleteAirportResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory DeleteAirportResponse.fromResponse(Response res) =>
      DeleteAirportResponse(status: res.status, message: res.message);
}
