import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightSendReportUseCase extends UseCase<FlightSendReportResponse,FlightSendReportRequest> {
  FlightSendReportUseCase();

  @override
  Future<Either<Failure, FlightSendReportResponse>> call({required FlightSendReportRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightSendReport(request);
  }

}

class FlightSendReportRequest extends Request {
  final String email;
  final String typeB;
  final Flight flight;
  final bool attachment;
  FlightSendReportRequest({required this.flight,required this.email,required this.typeB,required this.attachment});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightSendReport",
      "Token":token,
      "Request": {
          "Domain":"Desktop",
          "eMail":email,
          "TypeBAddress":typeB,
          "FlightScheduleID":flight.id,
          "Attachment":attachment,
          "Subject":"${flight.al}-${flight.flightNumber}    ${flight.from}-${flight.to}    ${flight.std}    ${flight.flightDate.format_ddMMMEEE}    ${flight.getAircraft?.registration??''}"
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightSendReportResponse extends Response {
  final String msg;
  FlightSendReportResponse({required int status, required String message, required this.msg})
      : super(
          status: status,
          message: message,
          body:message,
        );

    factory FlightSendReportResponse.fromResponse(Response res) => FlightSendReportResponse(
        status: res.status,
        message: res.message,
        msg:res.message,
      );

}
