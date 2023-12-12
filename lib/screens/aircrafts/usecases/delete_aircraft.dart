import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../aircrafts_repository.dart';

class DeleteAircraftUseCase extends UseCase<DeleteAircraftResponse, DeleteAircraftRequest> {
  DeleteAircraftUseCase();

  @override
  Future<Either<Failure, DeleteAircraftResponse>> call({required DeleteAircraftRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    AircraftsRepository repository = AircraftsRepository();
    return repository.deleteAircraft(request);
  }
}

class DeleteAircraftRequest extends Request {
  DeleteAircraftRequest({required this.id});

  final int id;

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "DeleteAircraft",
          "Request": {"ID": id}
        }
      };

  Failure? validate() {
    return null;
  }
}

class DeleteAircraftResponse extends Response {
  DeleteAircraftResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory DeleteAircraftResponse.fromResponse(Response res) =>
      DeleteAircraftResponse(status: res.status, message: res.message);
}
