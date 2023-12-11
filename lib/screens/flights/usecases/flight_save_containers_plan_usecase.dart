import 'package:brs_panel/core/classes/containers_plan_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_class.dart';
import '../flights_repository.dart';

class FlightSaveContainersPlanUseCase
    extends UseCase<FlightSaveContainersPlanResponse, FlightSaveContainersPlanRequest> {
  FlightSaveContainersPlanUseCase();

  @override
  Future<Either<Failure, FlightSaveContainersPlanResponse>> call({required FlightSaveContainersPlanRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightSaveContainersPlan(request);
  }
}

class FlightSaveContainersPlanRequest extends Request {
  final Flight f;
  final ContainersPlan plan;
  final int? secID;
  final int? spotID;

  FlightSaveContainersPlanRequest({required this.f, required this.plan, required this.secID, required this.spotID});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "FlightSaveContainersPlan",
          "Token": token,
          "Request": {
            "FlightID": f.id,
            "SectionID": secID,
            "SpotID": spotID,
            "PlanData": plan.planData.map((e) => e.toJson()).toList(),
          }
        }
      };


  Failure? validate() {
    return secID == null ? ValidationFailure(code: 1, msg: "Section is empty!", traceMsg: '') : null;
  }
}

class FlightSaveContainersPlanResponse extends Response {
  // final ContainersPlan plan;
  final String msg;

  FlightSaveContainersPlanResponse({required int status, required String message, required this.msg})
      : super(
          status: status,
          message: message,
          body: {
            // "ContainersPlan" : plan.toJson(),
          },
        );

  factory FlightSaveContainersPlanResponse.fromResponse(Response res) =>
      FlightSaveContainersPlanResponse(status: res.status, message: res.message, msg: res.message
          // plan:ContainersPlan.fromJson(res.body["ContainersPlan"]),
          );
}
