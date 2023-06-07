import 'dart:developer';
import 'package:brs_panel/screens/airline_ulds/usecases/airline_get_ulds_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/airline_ulds_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class AirlineUldsLocalDataSource implements AirlineUldsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  AirlineUldsLocalDataSource();

  @override
  Future<AirlineGetUldListResponse> airlineGetUldList({required AirlineGetUldListRequest request}) {
    // TODO: implement airlineGetUldList
    throw UnimplementedError();
  }



}
