import 'package:brs_panel/screens/flight_details/usecases/flight_get_details_usecase.dart';
import 'package:brs_panel/screens/flight_details/usecases/flight_get_tag_details_usecase.dart';
import 'package:brs_panel/screens/flight_details/usecases/get_container_pdf_usecase.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/flight_details_data_source_interface.dart';

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
}
