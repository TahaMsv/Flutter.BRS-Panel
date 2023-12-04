import 'dart:developer';
import 'package:brs_panel/screens/aircrafts/usecases/add_aircraft_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
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



}
