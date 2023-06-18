import 'package:brs_panel/core/classes/flight_details_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_class.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightGetContainerListUseCase extends UseCase<FlightGetContainerListResponse,FlightGetContainerListRequest> {
  FlightGetContainerListUseCase();

  @override
  Future<Either<Failure, FlightGetContainerListResponse>> call({required FlightGetContainerListRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightGetContainerList(request);
  }

}

class FlightGetContainerListRequest extends Request {
  final Flight f;
  FlightGetContainerListRequest({required this.f});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "FlightContainerList2",
      "Token":token,
      "Request": {
        "FlightScheduleID": f.id
      }
    }
  };

  Failure? validate(){
    return null;
  }
}


class FlightGetContainerListResponse extends Response {
  final List<TagContainer> cons;
  final List<String> destList;

  FlightGetContainerListResponse({required int status, required String message, required this.cons,required this.destList})
      : super(status: status, message: message, body: {
        "ContainerList":cons.map((e)=>e.toJson()).toList(),
        "DestList": destList.map((e) => {"Airport":e}).toList()
  });

  factory FlightGetContainerListResponse.fromResponse(Response res) => FlightGetContainerListResponse(
        status: res.status,
        message: res.message,
        cons: List<TagContainer>.from(res.body["ContainerList"].map((x) => TagContainer.fromJson(x))),
        destList: (res.body['DestList'] as List).map((x)=>x["Airport"].toString()).toList(),
      );
}
