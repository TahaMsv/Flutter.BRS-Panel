import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/flight_class.dart';
import 'package:brs_panel/screens/aircrafts/aircrafts_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/classes/user_class.dart';

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
        "Body": {
          "Token": token,
          "Execution": "AddUpdateAircraft",
          "Request": aircraft.toJson(),
        }
      };

  Failure? validate() {
    return null;
  }
}

class AddAirCraftResponse extends Response {
  final String msg;

  AddAirCraftResponse({required int status, required String message, required this.msg})
      : super(
          status: status,
          message: message,
          body: message,
        );

  factory AddAirCraftResponse.fromResponse(Response res) => AddAirCraftResponse(
        status: res.status,
        message: res.message,
        msg: res.message,
      );
}
