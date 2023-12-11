import 'package:dartz/dartz.dart';
import '../../../core/abstracts/failures_abs.dart';
import '../../../core/abstracts/request_abs.dart';
import '../../../core/abstracts/response_abs.dart';
import '../../../core/abstracts/usecase_abs.dart';
import '../special_reports_repository.dart';

class GetSpecialReportListUseCase extends UseCase<GetSpecialReportListResponse, GetSpecialReportListRequest> {
  GetSpecialReportListUseCase();

  @override
  Future<Either<Failure, GetSpecialReportListResponse>> call({required GetSpecialReportListRequest request}) {
    if (request.validate() != null) return Future(() => Left(request.validate()!));
    SpecialReportsRepository repository = SpecialReportsRepository();
    return repository.getSpecialReportsList(request);
  }
}

class GetSpecialReportListRequest extends Request {
  final int? reportType;

  GetSpecialReportListRequest({required this.reportType});

  @override
  Map<String, dynamic> toJson() => {
        "Body": {
          "Token": token,
          "Execution": "GetSpecialReportList",
          "Request": {"GroupID": reportType}
        }
      };

  Failure? validate() {
    return null;
  }
}

class GetSpecialReportListResponse extends Response {
  GetSpecialReportListResponse({required int status, required String message})
      : super(status: status, message: message, body: null);

  factory GetSpecialReportListResponse.fromResponse(Response res) {
    return GetSpecialReportListResponse(status: res.status, message: res.message);
  }
}
