import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/classes/login_user_class.dart';
import '../flight_details_repository.dart';

class GetContainerReportUseCase extends UseCase<GetContainerReportResponse, GetContainerReportRequest> {
  GetContainerReportUseCase();

  @override
  Future<Either<Failure, GetContainerReportResponse>> call({required GetContainerReportRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightDetailsRepository repository = FlightDetailsRepository();
    //todo
    return repository.getContainerReport(request);
  }
}

class GetContainerReportRequest extends Request {
  final UserSettings userSetting;
  final TagContainer con;

  GetContainerReportRequest({required this.con, required this.userSetting});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "GetContainerReport",
          "Request": {"ContainerID": con.id}
        }
      };

  Failure? validate() {
    return null;
  }
}

class GetContainerReportResponse extends Response {
  final String dataFile;

  GetContainerReportResponse({required int status, required String message, required this.dataFile})
      : super(status: status, message: message, body: null);

  factory GetContainerReportResponse.fromResponse(Response res) =>
      GetContainerReportResponse(status: res.status, message: res.message, dataFile: res.body["DataFile"]);
}
