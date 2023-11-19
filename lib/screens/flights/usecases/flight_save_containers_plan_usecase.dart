import 'package:brs_panel/core/classes/containers_plan_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightSaveContainersPlanUseCase extends UseCase<FlightSaveContainersPlanResponse,FlightSaveContainersPlanRequest> {
  FlightSaveContainersPlanUseCase();

  @override
  Future<Either<Failure, FlightSaveContainersPlanResponse>> call({required FlightSaveContainersPlanRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightSaveContainersPlan(request);
  }

}

class FlightSaveContainersPlanRequest extends Request {
  final Flight flight;
  final ContainersPlan plan;
  FlightSaveContainersPlanRequest({required this.flight,required this.plan});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightSaveContainersPlan",
      "Token":token,
      "Request": {
          "FlightScheduleID":flight.id,
          "PlanData":plan.planData.map((e) => e.toJson()).toList()
      }
    }
  };

  Failure? validate(){
    return null;
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

    factory FlightSaveContainersPlanResponse.fromResponse(Response res) => FlightSaveContainersPlanResponse(
        status: res.status,
        message: res.message,
        msg: res.message
        // plan:ContainersPlan.fromJson(res.body["ContainersPlan"]),
      );

}

