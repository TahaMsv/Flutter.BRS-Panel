import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../bsm_repository.dart';

class AddBSMUseCase extends UseCase<AddBSMResponse, AddBSMRequest> {
  AddBSMUseCase();

  @override
  Future<Either<Failure, AddBSMResponse>> call({required AddBSMRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    BsmRepository repository = BsmRepository();
    return repository.addBsm(request);
  }
}

class AddBSMRequest extends Request {
  final String msg;

  AddBSMRequest({required this.msg});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Execution": "BSMSubmit",
          "Token": token,
          "Request": {
            "BSMBody": msg,
          }
        }
      };

  Failure? validate() {
    return null;
  }
}

class AddBSMResponse extends Response {
  final BsmResult bsmResult;

  AddBSMResponse({required int status, required String message, required this.bsmResult})
      : super(
          status: status,
          message: message,
          body:bsmResult.toJson(),
        );

  factory AddBSMResponse.fromResponse(Response res) => AddBSMResponse(
        status: res.status,
        message: res.message,
        bsmResult: BsmResult.fromJson(res.body),
      );
}
