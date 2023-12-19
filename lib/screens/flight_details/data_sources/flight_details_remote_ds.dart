import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../interfaces/flight_details_data_source_interface.dart';
import '../usecases/delete_tag_usecase.dart';
import '../usecases/flight_get_details_usecase.dart';
import '../usecases/flight_get_tag_details_usecase.dart';
import '../usecases/get_container_pdf_usecase.dart';
import '../usecases/get_history_log_usecase.dart';
import 'flight_details_local_ds.dart';

class FlightDetailsRemoteDataSource implements FlightDetailsDataSourceInterface {
  final FlightDetailsLocalDataSource localDataSource = FlightDetailsLocalDataSource();
  final NetworkManager networkManager = NetworkManager();

  FlightDetailsRemoteDataSource();

  @override
  Future<FlightGetDetailsResponse> flightGetDetails({required FlightGetDetailsRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightGetDetailsResponse.fromResponse(res);
  }

  @override
  Future<FlightGetTagMoreDetailsResponse> flightGetTagMoreDetails(
      {required FlightGetTagMoreDetailsRequest request}) async {
    Response res = await networkManager.post(request);
    return FlightGetTagMoreDetailsResponse.fromResponse(res);
  }

  @override
  Future<GetContainerReportResponse> getContainerReport({required GetContainerReportRequest request}) async {
    Response res = await networkManager.post(request);
    return GetContainerReportResponse.fromResponse(res);
  }

  @override
  Future<DeleteTagResponse> deleteTag({required DeleteTagRequest request}) async {
    Response res = await networkManager.post(request);
    return DeleteTagResponse.fromResponse(res);
  }

  @override
  Future<GetHistoryLogResponse> getHistoryLog({required GetHistoryLogRequest request}) async {
    Response res = await networkManager.post(request);
    return GetHistoryLogResponse.fromResponse(res);
  }
}
