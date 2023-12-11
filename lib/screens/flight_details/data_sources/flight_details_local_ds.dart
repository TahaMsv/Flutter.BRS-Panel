import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/flight_details_data_source_interface.dart';
import '../usecases/delete_tag_usecase.dart';
import '../usecases/flight_get_details_usecase.dart';
import '../usecases/flight_get_tag_details_usecase.dart';
import '../usecases/get_container_pdf_usecase.dart';
import '../usecases/get_history_log_usecase.dart';

const String userJsonLocalKey = "UserJson";

class FlightDetailsLocalDataSource implements FlightDetailsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  FlightDetailsLocalDataSource();

  @override
  Future<FlightGetDetailsResponse> flightGetDetails({required FlightGetDetailsRequest request}) {
    // TODO: implement flightGetDetails
    throw UnimplementedError();
  }

  @override
  Future<FlightGetTagMoreDetailsResponse> flightGetTagMoreDetails({required FlightGetTagMoreDetailsRequest request}) {
    // TODO: implement flightGetTagMoreDetails
    throw UnimplementedError();
  }

  @override
  Future<GetContainerReportResponse> getContainerReport({required GetContainerReportRequest request}) {
    // TODO: implement getContainerReport
    throw UnimplementedError();
  }

  @override
  Future<DeleteTagResponse> deleteTag({required DeleteTagRequest request}) {
    // TODO: implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<GetHistoryLogResponse> getHistoryLog({required GetHistoryLogRequest request}) {
    // TODO: implement deleteTag
    throw UnimplementedError();
  }
}
