import 'package:brs_panel/core/classes/special_report_result_class.dart';
import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../../../core/classes/special_report_param_class.dart';
import '../../../core/classes/special_report_param_option_class.dart';
import '../../../core/classes/user_class.dart';
import '../special_reports_repository.dart';

class GetSpecialReportResultUseCase extends UseCase<GetSpecialReportResultResponse, GetSpecialReportResultRequest> {
  GetSpecialReportResultUseCase();

  @override
  Future<Either<Failure, GetSpecialReportResultResponse>> call({required GetSpecialReportResultRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    SpecialReportsRepository repository = SpecialReportsRepository();
    return repository.getSpecialReportResult(request);
  }
}

class GetSpecialReportResultRequest extends Request {
  final int reportID;
  final Map<SpecialReportParam, ParamOption> params;

  GetSpecialReportResultRequest({required this.params, required this.reportID});

  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> paramJson = [];
    params.forEach((key, value) {
      paramJson.add({"ID": key.id, "Value": value.value, "Label": key.label});
    });
    return {
      "Body": {
        "Token": token,
        "Execution": "GetSpecialReport",
        "Request": {"ReportID": reportID, "Parameters": paramJson}
      }
    };
  }

  Failure? validate() {
    return null;
  }
}

class GetSpecialReportResultResponse extends Response {
  final SpecialReportResult result;

  GetSpecialReportResultResponse({required int status, required String message, required this.result})
      : super(
          status: status,
          message: message,
          body: result.toJson(),
        );

  factory GetSpecialReportResultResponse.fromResponse(Response res) => GetSpecialReportResultResponse(
        status: res.status,
        message: res.message,
        result: SpecialReportResult.fromJson(res.body),
      );
}

