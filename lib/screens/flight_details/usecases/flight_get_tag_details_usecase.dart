import 'package:brs_panel/core/classes/tag_more_details_class.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../../../core/classes/user_class.dart';
import '../flight_details_repository.dart';

class FlightGetTagMoreDetailsUseCase extends UseCase<FlightGetTagMoreDetailsResponse,FlightGetTagMoreDetailsRequest> {
  FlightGetTagMoreDetailsUseCase();

  @override
  Future<Either<Failure, FlightGetTagMoreDetailsResponse>> call({required FlightGetTagMoreDetailsRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightDetailsRepository repository = FlightDetailsRepository();
    return repository.flightGetTagMoreDetails(request);
  }

}

class FlightGetTagMoreDetailsRequest extends Request {
  final int flightID;
  final FlightTag tag;
  FlightGetTagMoreDetailsRequest({required this.flightID,required this.tag});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Token":token,
      "Execution": "ReadPhoto",
      "Request": {"FlightScheduleID": flightID, "TagNumber": tag.tagNumber}
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightGetTagMoreDetailsResponse extends Response {
  final TagMoreDetails details;
  FlightGetTagMoreDetailsResponse({required int status, required String message, required this.details})
      : super(
          status: status,
          message: message,
          body: details.toJson(),
        );

    factory FlightGetTagMoreDetailsResponse.fromResponse(Response res) => FlightGetTagMoreDetailsResponse(
        status: res.status,
        message: res.message,
        details:TagMoreDetails.fromJson(res.body),
      );

}
