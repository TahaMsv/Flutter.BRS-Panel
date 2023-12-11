import 'package:brs_panel/core/classes/special_report_param_option_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/special_report_class.dart';
import '../../../core/classes/user_class.dart';
import '../special_reports_repository.dart';

class GetParamsOptionsUseCase extends UseCase<GetParamsOptionsResponse,GetParamsOptionsRequest> {
  GetParamsOptionsUseCase();

  @override
  Future<Either<Failure, GetParamsOptionsResponse>> call({required GetParamsOptionsRequest request}) {
  if(request.validate()!=null) return Future(() =>Left(request.validate()!));
    SpecialReportsRepository repository = SpecialReportsRepository();
    return repository.getParamsOptions(request);
  }

}

class GetParamsOptionsRequest extends Request {
  final SpecialReport report;
  GetParamsOptionsRequest({required this.report});

  @override
  Map<String, dynamic> toJson() =>{
    "Body": {
      "Token":token,
      "Execution": "GetSpecialReportParameterOptions",
      "Request": {
        "ParameterIDs": report.getParameters.join(","),
      }
    }
  };

  Failure? validate(){
    return null;
  }
}



class GetParamsOptionsResponse extends Response {
  final List<SpecialReportParameterOptions> options;

  GetParamsOptionsResponse({required int status, required String message, required this.options})
      : super(status: status, message: message, body:{"ParameterOptions": options.map((e)=>e.toJson()).toList()});

  factory GetParamsOptionsResponse.fromResponse(Response res) => GetParamsOptionsResponse(
        status: res.status,
        message: res.message,
        options: List<SpecialReportParameterOptions>.from(res.body["ParameterOptions"].map((x) => SpecialReportParameterOptions.fromJson(x))),
      );
}
