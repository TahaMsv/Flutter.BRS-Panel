import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/special_reports_data_source_interface.dart';
import '../usecases/get_sr_list_usecase.dart';

const String userJsonLocalKey = "UserJson";

class SpecialReportsLocalDataSource implements SpecialReportsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  SpecialReportsLocalDataSource();

  @override
  Future<GetSpecialReportListResponse> getSpecialReportsList({required GetSpecialReportListRequest request}) {
    // TODO: implement getSpecialReportsList
    throw UnimplementedError();
  }
}
