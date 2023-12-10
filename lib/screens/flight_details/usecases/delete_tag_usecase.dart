import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/flight_details_class.dart';
import '../flight_details_repository.dart';

class DeleteTagUseCase extends UseCase<DeleteTagResponse, DeleteTagRequest> {
  DeleteTagUseCase();

  @override
  Future<Either<Failure, DeleteTagResponse>> call({required DeleteTagRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    FlightDetailsRepository repository = FlightDetailsRepository();
    return repository.deleteTag(request);
  }
}

class DeleteTagRequest extends Request {
  final int flightID;
  final FlightTag tag;

  DeleteTagRequest({required this.flightID, required this.tag});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "DeleteTag",
          "Request": {"FlightID": flightID, "TagID": tag.tagId}
        }
      };

  Failure? validate() {
    return null;
  }
}

class DeleteTagResponse extends Response {
  DeleteTagResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory DeleteTagResponse.fromResponse(Response res) => DeleteTagResponse(status: res.status, message: res.message);
}
