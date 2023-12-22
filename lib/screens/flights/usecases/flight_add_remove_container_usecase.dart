import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../flights_repository.dart';

class FlightAddRemoveContainerUseCase extends UseCase<FlightAddRemoveContainerResponse, FlightAddRemoveContainerRequest> {
  FlightAddRemoveContainerUseCase();

  @override
  Future<Either<Failure, FlightAddRemoveContainerResponse>> call({required FlightAddRemoveContainerRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightAddRemoveContainer(request);
  }
}

class FlightAddRemoveContainerRequest extends Request {
  final Flight flight;
  final TagContainer con;
  final bool isAdd;
  final bool isForce;

  FlightAddRemoveContainerRequest({required this.flight, required this.con, required this.isAdd, required this.isForce});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "AssignContainerToFlight",
          "Token": token,
          "Request": {
            "FlightScheduleID": isAdd ? flight.id : con.flightID,
            "ContainerID": con.id!,
            "SpotID": con.spotID,
            "ShootID": con.shootID,
            "DestList": con.destList, //it shouldn't be a list! just a string!
            "ClassList": con.classTypeList,
            "TagTypeIDs": con.tagTypeIds,
            "ClassTypeID": 1,
            "PositionID": null, //con.positionID,
            "IsDeleted": isAdd ? 0 : 1,
            "IsForced": isForce,
            "SectionID": con.sectionID,
            "AL": isAdd ? flight.al : con.al,
            "FLNB": isAdd ? flight.flightNumber : con.flnb,

            // "Destination": con.dest,
            // "ClassTypeID": con.classTypeID,
          },
        }
      };

  Failure? validate() {
    return null;
  }
}

class FlightAddRemoveContainerResponse extends Response {
  final List<TagContainer> containers;

  FlightAddRemoveContainerResponse({required int status, required String message, required this.containers})
      : super(
          status: status,
          message: message,
          body: containers.map((x) => x.toJson()).toList(),
        );

  factory FlightAddRemoveContainerResponse.fromResponse(Response res) => FlightAddRemoveContainerResponse(
        status: res.status,
        message: res.message,
        containers: List<TagContainer>.from(res.body["SetContainers"].map((x) => TagContainer.fromJson(x))),
      );
}

class FlightAddRemoveContainer extends Response {
  final List<TagContainer> containers;

  FlightAddRemoveContainer({required int status, required String message, required this.containers}) : super(status: status, message: message, body: containers.map((e) => e.toJson()).toList());

  factory FlightAddRemoveContainer.fromResponse(Response res) => FlightAddRemoveContainer(
        status: res.status,
        message: res.message,
        containers: List<TagContainer>.from(res.body["TagContainerList"].map((x) => TagContainer.fromJson(x))),
      );
}
