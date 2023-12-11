import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../flight_details_repository.dart';

class GetHistoryLogUseCase extends UseCase<GetHistoryLogResponse, GetHistoryLogRequest> {
  GetHistoryLogUseCase();

  @override
  Future<Either<Failure, GetHistoryLogResponse>> call({required GetHistoryLogRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightDetailsRepository repository = FlightDetailsRepository();
    return repository.getHistoryLog(request);
  }
}

class GetHistoryLogRequest extends Request {
  final String? airport;
  final int? flightID;
  final int? tagID;
  final int? userID;

  GetHistoryLogRequest({required this.airport, required this.flightID, required this.tagID, required this.userID});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "GetHistoryLog",
          "Request": {
            "Airport": airport,
            "FlightID": flightID,
            "TagID": tagID,
            "UserID": userID,
          }
        }
      };

  Failure? validate() {
    String msg = (airport == null && flightID == null && tagID == null && userID == null) ? "Missing information" : "";
    return msg.isEmpty ? null : ValidationFailure(code: 1, msg: msg, traceMsg: '');
  }
}

class GetHistoryLogResponse extends Response {
  GetHistoryLogResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory GetHistoryLogResponse.fromResponse(Response res) =>
      GetHistoryLogResponse(status: res.status, message: res.message);
}
