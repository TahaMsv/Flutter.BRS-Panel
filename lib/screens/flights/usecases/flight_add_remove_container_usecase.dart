import 'package:brs_panel/core/classes/flight_details_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightAddRemoveContainerUseCase extends UseCase<FlightAddRemoveContainerResponse,FlightAddRemoveContainerRequest> {
  FlightAddRemoveContainerUseCase();

  @override
  Future<Either<Failure, FlightAddRemoveContainerResponse>> call({required FlightAddRemoveContainerRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightAddRemoveContainer(request);
  }

}

class FlightAddRemoveContainerRequest extends Request {
  FlightAddRemoveContainerRequest();

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightAddRemoveContainer",
      "Token":token,
      "Request": {
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightAddRemoveContainerResponse extends Response {
  final TagContainer container;
  FlightAddRemoveContainerResponse({required int status, required String message, required this.container})
      : super(
          status: status,
          message: message,
          body: {
            "TagContainer" : container.toJson(),
          },
        );

    factory FlightAddRemoveContainerResponse.fromResponse(Response res) => FlightAddRemoveContainerResponse(
        status: res.status,
        message: res.message,
        container:TagContainer.fromJson(res.body["TagContainer"]),
      );

}

class FlightAddRemoveContainer extends Response {
  final List<TagContainer> containers;

  FlightAddRemoveContainer({required int status, required String message, required this.containers})
      : super(status: status, message: message, body:{"TagContainerList": containers.map((e)=>e.toJson()).toList()});

  factory FlightAddRemoveContainer.fromResponse(Response res) => FlightAddRemoveContainer(
        status: res.status,
        message: res.message,
        containers: List<TagContainer>.from(res.body["TagContainerList"].map((x) => TagContainer.fromJson(x))),
      );
}
