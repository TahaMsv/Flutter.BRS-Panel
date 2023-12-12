import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/airport_class.dart';
import '../airports_repository.dart';

class AddUpdateAirportUseCase extends UseCase<AddUpdateAirportResponse, AddUpdateAirportRequest> {
  AddUpdateAirportUseCase();

  @override
  Future<Either<Failure, AddUpdateAirportResponse>> call({required AddUpdateAirportRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AirportsRepository repository = AirportsRepository();
    return repository.addUpdateAirport(request);
  }
}

class AddUpdateAirportRequest extends Request {
  AddUpdateAirportRequest(
      {required this.code,
      required this.cityName,
      required this.strTimeZone,
      required this.timeZone,
      required this.isUpdate});

  final String code;
  final String cityName;
  final String? strTimeZone;
  final int? timeZone;
  final bool isUpdate;

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "AddUpdateAirport",
          "Request": {
            "Code": code,
            "CityName": cityName,
            "STRTimeZone": strTimeZone,
            "TimeZone": timeZone,
            "IsUpdate": isUpdate
          }
        }
      };

  Failure? validate() {
    String msg = '';
    if (code.isEmpty) {
      msg = "Code is empty!";
    } else if (cityName.isEmpty) {
      msg = "City name is empty!";
    } else if (timeZone == null) {
      msg = "Timezone is not set!";
    }
    return msg.isEmpty ? null : ValidationFailure(code: 1, msg: msg, traceMsg: "");
  }
}

class AddUpdateAirportResponse extends Response {
  final DetailedAirport airport;

  AddUpdateAirportResponse({required int status, required String message, required this.airport})
      : super(status: status, message: message, body: airport.toJson());

  factory AddUpdateAirportResponse.fromResponse(Response res) => AddUpdateAirportResponse(
      status: res.status, message: res.message, airport: DetailedAirport.fromJson(res.body["Airports"][0]));
}
