import 'package:brs_panel/core/util/basic_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../flight_details_repository.dart';

class FlightGetDetailsUseCase extends UseCase<FlightGetDetailsResponse,FlightGetDetailsRequest> {
  FlightGetDetailsUseCase();

  @override
  Future<Either<Failure, FlightGetDetailsResponse>> call({required FlightGetDetailsRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightDetailsRepository repository = FlightDetailsRepository();
    return repository.flightGetDetails(request);
  }

}

class FlightGetDetailsRequest extends Request {
  final int flightID;
  FlightGetDetailsRequest({required this.flightID});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Token":token,
      "Execution": "FlightDetails",
      "Request": {
        "FlightScheduleID": flightID,
        "Position": null,
        "Airport": BasicClass.userSetting.airport
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightGetDetailsResponse extends Response {
  final FlightDetails details;
  FlightGetDetailsResponse({required int status, required String message, required this.details})
      : super(
          status: status,
          message: message,
          body: details.toJson(),
        );

    factory FlightGetDetailsResponse.fromResponse(Response res) => FlightGetDetailsResponse(
        status: res.status,
        message: res.message,
        details:FlightDetails.fromJson(res.body),
      );

}
