import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:brs_panel/core/util/basic_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../flights_repository.dart';

class FlightListUseCase extends UseCase<FlightListResponse, FlightListRequest> {
  @override
  Future<Either<Failure, FlightListResponse>> call({required FlightListRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightsRepository repository = FlightsRepository();
    return repository.flightList(request);
  }
}

class FlightListRequest extends Request {
  final DateTime dateTime;

  FlightListRequest({
    required this.dateTime,
  });

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "FlightList2",
          "Token": token,
          "Request": {
            "Date": dateTime.format_yyyyMMdd,
            "Airport": BasicClass.userSetting.airport,
            "AL": BasicClass.userSetting.al
          }
        }
      };

  Failure? validate() {
    return null;
  }
}

class FlightListResponse extends Response {
  final List<Flight> flights;

  FlightListResponse({required int status, required String message, required this.flights}) : super(status: status, message: message, body: flights.map((e) => e.toJson()).toList());

  factory FlightListResponse.fromResponse(Response res) => FlightListResponse(
        status: res.status,
        message: res.message,
        flights: List<Flight>.from(
          res.body.map((x) => Flight.fromJson(x)),
        ),
      );
}
