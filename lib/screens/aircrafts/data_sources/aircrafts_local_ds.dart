import 'package:brs_panel/screens/aircrafts/usecases/add_aircraft_usecase.dart';
import 'package:brs_panel/screens/aircrafts/usecases/delete_aircraft.dart';
import 'package:brs_panel/screens/aircrafts/usecases/get_aircraft_list.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../initialize.dart';
import '../interfaces/aircrafts_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class AircraftsLocalDataSource implements AircraftsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();

  AircraftsLocalDataSource();

  @override
  Future<AddAirCraftResponse> addAirCraft({required AddAirCraftRequest request}) {
    // TODO: implement addAirCraft
    throw UnimplementedError();
  }

  @override
  Future<DeleteAircraftResponse> deleteAircraft({required DeleteAircraftRequest request}) {
    // TODO: implement deleteAirCraft
    throw UnimplementedError();
  }

  @override
  Future<GetAircraftListResponse> getAircraftList({required GetAircraftListRequest request}) {
    // TODO: implement getAircraftList
    throw UnimplementedError();
  }
}
