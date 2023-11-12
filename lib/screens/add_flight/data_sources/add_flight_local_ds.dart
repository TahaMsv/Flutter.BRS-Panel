import 'dart:developer';
import 'package:brs_panel/screens/add_flight/usecases/add_flight_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/login_user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/add_flight_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class AddFlightLocalDataSource implements AddFlightDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  AddFlightLocalDataSource();

  @override
  Future<AddFlightResponse> addFlight({required AddFlightRequest request}) {
    // TODO: implement addFlight
    throw UnimplementedError();
  }



}
