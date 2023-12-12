import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/airports_data_source_interface.dart';
import '../usecases/add_update_airport.dart';
import '../usecases/delete_airport.dart';
import '../usecases/get_airport_list.dart';

const String userJsonLocalKey = "UserJson";

class AirportsLocalDataSource implements AirportsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  AirportsLocalDataSource();

  @override
  Future<GetAirportListResponse> getAirportList({required GetAirportListRequest request}) {
    // TODO: implement getAirportList
    throw UnimplementedError();
  }

  @override
  Future<AddUpdateAirportResponse> addUpdateAirport({required AddUpdateAirportRequest request}) {
    // TODO: implement addUpdateAirport
    throw UnimplementedError();
  }

  @override
  Future<DeleteAirportResponse> deleteAirport({required DeleteAirportRequest request}) {
    // TODO: implement deleteAirport
    throw UnimplementedError();
  }
}
