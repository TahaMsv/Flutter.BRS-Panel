import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/history_log_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../flight_summary_repository.dart';

class FlightGetHistoryLogUseCase extends UseCase<FlightGetHistoryLogResponse,FlightGetHistoryLogRequest> {
  FlightGetHistoryLogUseCase();

  @override
  Future<Either<Failure, FlightGetHistoryLogResponse>> call({required FlightGetHistoryLogRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightSummaryRepository repository = FlightSummaryRepository();
    return repository.flightGetHistoryLog(request);
  }

}

class FlightGetHistoryLogRequest extends Request {
  final String? airport;
  final int? flightID;
  final int? tagID;
  final int? userID;
  FlightGetHistoryLogRequest({
    required this.airport,
    required this.flightID,
    required this.tagID,
    required this.userID,
});

  @override
  Map<String, dynamic> toJson() =>{
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

  Failure? validate(){
    return null;
  }
}


class FlightGetHistoryLogResponse extends Response {
  final HistoryLog logs;
  FlightGetHistoryLogResponse({required int status, required String message, required this.logs})
      : super(
          status: status,
          message: message,
          body:  logs.toJson(),
        );

    factory FlightGetHistoryLogResponse.fromResponse(Response res) => FlightGetHistoryLogResponse(
        status: res.status,
        message: res.message,
        logs:HistoryLog.fromJson(res.body),
      );

}