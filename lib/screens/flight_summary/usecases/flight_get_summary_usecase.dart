import 'package:brs_panel/core/classes/flight_summary_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../flight_summary_repository.dart';

class FlightGetSummaryUseCase extends UseCase<FlightGetSummaryResponse,FlightGetSummaryRequest> {
  FlightGetSummaryUseCase();

  @override
  Future<Either<Failure, FlightGetSummaryResponse>> call({required FlightGetSummaryRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightSummaryRepository repository = FlightSummaryRepository();
    return repository.flightGetSummary(request);
  }

}

class FlightGetSummaryRequest extends Request {
  final int flightID;
  FlightGetSummaryRequest({required this.flightID});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightSummary",
      "Token":token,
      "Request": {
        "FlightSchedule_ID": flightID
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightGetSummaryResponse extends Response {
  final FlightSummary summary;
  FlightGetSummaryResponse({required int status, required String message, required this.summary})
      : super(
          status: status,
          message: message,
          body: summary.toJson(),
        );

    factory FlightGetSummaryResponse.fromResponse(Response res) => FlightGetSummaryResponse(
        status: res.status,
        message: res.message,
        summary:FlightSummary.fromJson(res.body),
      );

}

