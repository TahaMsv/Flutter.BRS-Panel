import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/containers_plan_class.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightGetContainersPlanUseCase extends UseCase<FlightGetContainersPlanResponse,FlightGetContainersPlanRequest> {
  FlightGetContainersPlanUseCase();

  @override
  Future<Either<Failure, FlightGetContainersPlanResponse>> call({required FlightGetContainersPlanRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightGetContainersPlan(request);
  }

}

class FlightGetContainersPlanRequest extends Request {
  final Flight flight;
  FlightGetContainersPlanRequest({required this.flight});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightGetContainersPlan",
      "Token":token,
      "Request": {
        "FlightID": flight.id
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightGetContainersPlanResponse extends Response {
  final ContainersPlan plan;
  FlightGetContainersPlanResponse({required int status, required String message, required this.plan})
      : super(
          status: status,
          message: message,
          body: plan.toJson(),
        );

    factory FlightGetContainersPlanResponse.fromResponse(Response res) => FlightGetContainersPlanResponse(
        status: res.status,
        message: res.message,
        plan:ContainersPlan.fromJson(res.body),

      );

}

