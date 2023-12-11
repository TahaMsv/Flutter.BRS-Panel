import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../../../core/util/parser.dart';
import '../interfaces/special_reports_data_source_interface.dart';
import '../usecases/get_params_options_usecase.dart';
import '../usecases/get_special_report_result_usecase.dart';
import '../usecases/get_sr_list_usecase.dart';
import 'special_reports_local_ds.dart';

class SpecialReportsRemoteDataSource implements SpecialReportsDataSourceInterface {
  final SpecialReportsLocalDataSource localDataSource = SpecialReportsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  SpecialReportsRemoteDataSource();

  @override
  Future<GetSpecialReportListResponse> getSpecialReportsList({required GetSpecialReportListRequest request}) async {
    Response res = await networkManager.post(request);
    print("res.body");
    print(res.body);
    return GetSpecialReportListResponse.fromResponse(res);
  }

  @override
  Future<GetParamsOptionsResponse> getParamsOptions({required GetParamsOptionsRequest request}) async {
    Response res = await networkManager.post(request);
    GetParamsOptionsResponse response = await Parser().pars(GetParamsOptionsResponse.fromResponse, res);
    return response;
  }

    @override
      Future<GetSpecialReportResultResponse> getSpecialReportResult({required GetSpecialReportResultRequest request}) async {
        Response res = await networkManager.post(request);
        GetSpecialReportResultResponse response = await Parser().pars(GetSpecialReportResultResponse.fromResponse, res);
        return response;
      }

}
