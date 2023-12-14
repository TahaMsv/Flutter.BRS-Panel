import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../aircrafts_repository.dart';

class GetAircraftListUseCase extends UseCase<GetAircraftListResponse, GetAircraftListRequest> {
  GetAircraftListUseCase();

  @override
  Future<Either<Failure, GetAircraftListResponse>> call({required GetAircraftListRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AircraftsRepository repository = AircraftsRepository();
    return repository.getAircraftList(request);
  }
}

class GetAircraftListRequest extends Request {
  GetAircraftListRequest({required this.al});

  final String al;

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "AircraftList",
          "Request": {"AL": al}
        }
      };

  Failure? validate() {
    return null;
  }
}

class GetAircraftListResponse extends Response {
  final List<Aircraft> aircrafts;

  GetAircraftListResponse({required int status, required String message, required this.aircrafts})
      : super(status: status, message: message, body: aircrafts.map((e) => e.toJson()).toList());

  factory GetAircraftListResponse.fromResponse(Response res) => GetAircraftListResponse(
      status: res.status,
      message: res.message,
      aircrafts: List<Aircraft>.from(res.body.map((x) => Aircraft.fromJson(x))));
}
