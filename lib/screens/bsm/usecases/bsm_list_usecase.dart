import 'package:artemis_utils/artemis_utils.dart';
import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/user_class.dart';
import '../bsm_repository.dart';

class BsmListUseCase extends UseCase<BsmListResponse,BsmListRequest> {
  BsmListUseCase();

  @override
  Future<Either<Failure, BsmListResponse>> call({required BsmListRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    BsmRepository repository = BsmRepository();
    return repository.bsmList(request);
  }

}

class BsmListRequest extends Request {
  final DateTime date;
  BsmListRequest({required this.date});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Execution": "BSMList",
      "Token":token,
      "Request": {
        "Date": date.format_yyyyMMdd
      }
    }
  };

  Failure? validate(){
    return null;
  }
}



class BsmListResponse extends Response {
  final List<BsmResult> bsmLists;

  BsmListResponse({required int status, required String message, required this.bsmLists})
      : super(status: status, message: message, body:{"BSMList": bsmLists.map((e)=>e.toJson()).toList()});

  factory BsmListResponse.fromResponse(Response res) => BsmListResponse(
        status: res.status,
        message: res.message,
        bsmLists: List<BsmResult>.from(res.body["BSMList"].map((x) => BsmResult.fromJson(x))),
      );
}
