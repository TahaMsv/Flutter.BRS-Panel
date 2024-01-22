import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../flights_repository.dart';

class FlightGetPlanFileUseCase extends UseCase<FlightGetPlanFileResponse, FlightGetPlanFileRequest> {
  FlightGetPlanFileUseCase();

  @override
  Future<Either<Failure, FlightGetPlanFileResponse>> call({required FlightGetPlanFileRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightGetPlanFile(request);
  }
}

class FlightGetPlanFileRequest extends Request {
  final List<int> typeIDs;
  final int flightID;

  FlightGetPlanFileRequest({required this.flightID, required this.typeIDs});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "FlightGetPlanFile",
          "Token": token,
          "Request": {"FlightScheduleID": flightID, "TagTypeId": typeIDs}
        }
      };

  Failure? validate() {
    return null;
  }
}

class FlightGetPlanFileResponse extends Response {
  final String data;

  FlightGetPlanFileResponse({required int status, required String message, required this.data})
      : super(
          status: status,
          message: message,
          body: {
            "DataFile": data,
          },
        );

  factory FlightGetPlanFileResponse.fromResponse(Response res) => FlightGetPlanFileResponse(
        status: res.status,
        message: res.message,
        data: res.body["DataFile"],
      );
}
