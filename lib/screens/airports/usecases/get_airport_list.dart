import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_class.dart';
import '../airports_repository.dart';

class GetAirportListUseCase extends UseCase<GetAirportListResponse, GetAirportListRequest> {
  GetAirportListUseCase();

  @override
  Future<Either<Failure, GetAirportListResponse>> call({required GetAirportListRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportsRepository repository = AirportsRepository();
    return repository.getAirportList(request);
  }
}

class GetAirportListRequest extends Request {
  GetAirportListRequest();

  @override
  Map<String, dynamic> toJson() => {
        "Body": {"Token": token, "Execution": "AirportList"}
      };

  Failure? validate() {
    return null;
  }
}

class GetAirportListResponse extends Response {
  final DetailedAirports airports;

  GetAirportListResponse({required int status, required String message, required this.airports})
      : super(status: status, message: message, body: airports.toJson());

  factory GetAirportListResponse.fromResponse(Response res) =>
      GetAirportListResponse(status: res.status, message: res.message, airports: DetailedAirports.fromJson(res.body));
}
