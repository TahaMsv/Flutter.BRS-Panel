import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_report_class.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightGetReportUseCase extends UseCase<FlightGetReportResponse,FlightGetReportRequest> {
  FlightGetReportUseCase();

  @override
  Future<Either<Failure, FlightGetReportResponse>> call({required FlightGetReportRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightGetReport(request);
  }

}

class FlightGetReportRequest extends Request {
  final int flightID;
  FlightGetReportRequest({required this.flightID});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightReport",
      "Token":token,
      "Request": {
        "FlightScheduleID": flightID
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightGetReportResponse extends Response {
  final FlightReport report;
  FlightGetReportResponse({required int status, required String message, required this.report})
      : super(
          status: status,
          message: message,
          body:  report.toJson(),
        );

    factory FlightGetReportResponse.fromResponse(Response res) => FlightGetReportResponse(
        status: res.status,
        message: res.message,
        report:FlightReport.fromJson(res.body),
      );

}
