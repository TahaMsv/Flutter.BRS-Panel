import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../aircrafts_repository.dart';

class AddAirCraftUseCase extends UseCase<AddAirCraftResponse, AddAirCraftRequest> {
  AddAirCraftUseCase();

  @override
  Future<Either<Failure, AddAirCraftResponse>> call({required AddAirCraftRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AircraftsRepository repository = AircraftsRepository();
    return repository.addAirCraft(request);
  }
}

class AddAirCraftRequest extends Request {
  final Aircraft aircraft;

  AddAirCraftRequest({required this.aircraft});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {"Token": token, "Execution": "AddUpdateAircraft", "Request": aircraft.toJson()}
      };

  Failure? validate() {
    String msg = '';
    if (aircraft.al.isEmpty) {
      msg = "Al should not be empty";
    } else if (aircraft.aircraftType.isEmpty) {
      msg = "Type should not be empty";
    } else if (aircraft.registration.isEmpty) {
      msg = "Registration should not be empty";
    }
    return msg.isEmpty ? null : ValidationFailure(code: 1, msg: msg, traceMsg: "");
  }
}

class AddAirCraftResponse extends Response {
  final Aircraft aircraft;

  AddAirCraftResponse({required int status, required String message, required this.aircraft})
      : super(status: status, message: message, body: message);

  factory AddAirCraftResponse.fromResponse(Response res) => AddAirCraftResponse(
      status: res.status, message: res.message, aircraft: Aircraft.fromJson(res.body["AircraftList"][0]));
}
