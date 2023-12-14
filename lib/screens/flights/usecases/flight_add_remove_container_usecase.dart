import 'package:brs_panel/core/classes/flight_details_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/login_user_class.dart';
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
  final Flight flight;
  final TagContainer con;
  final bool isAdd;
  FlightAddRemoveContainerRequest({required this.flight,required this.con,required this.isAdd});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "AssignContainerToFlight",
      "Token":token,
      "Request": {
        "FlightScheduleID": isAdd?flight.id:con.flightID,
        "ContainerID": con.id!,
        "Destination": con.dest,
        "DestList":con.destList,
        "ClassList":con.classTypeList,
        // "ClassTypeID": con.classTypeID,
        "IsDeleted": isAdd?0:1,
        "SpotID": con.spotID,
        "ShootID": con.shootID,
        "TagTypeIDs": con.tagTypeIds,
        "ClassTypeID": 1,
        // "PositionID": positionID,
        // "IsDeleted": assign ? 0 : 1,
        // "IsForced": isForce,
        "SectionID": con.sectionID
      },
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
          body: container.toJson(),
        );

    factory FlightAddRemoveContainerResponse.fromResponse(Response res) => FlightAddRemoveContainerResponse(
        status: res.status,
        message: res.message,

        container:TagContainer.fromJson(res.body),
      );

}

class FlightAddRemoveContainer extends Response {
  final List<TagContainer> containers;

  FlightAddRemoveContainer({required int status, required String message, required this.containers})
      : super(status: status, message: message, body: containers.map((e)=>e.toJson()).toList());

  factory FlightAddRemoveContainer.fromResponse(Response res) => FlightAddRemoveContainer(
        status: res.status,
        message: res.message,
        containers: List<TagContainer>.from(res.body["TagContainerList"].map((x) => TagContainer.fromJson(x))),
      );
}
