import 'dart:developer';
import 'package:brs_panel/screens/airport_carts/usecase/airport_get_carts_usecase.dart';

import '../../../core/abstracts/exception_abs.dart';
import '../../../core/abstracts/local_data_base_abs.dart';
import '../../../core/classes/user_class.dart';
import '../../../core/data_base/classes/db_user_class.dart';
import '../../../core/data_base/local_data_base.dart';
import '../../../core/data_base/table_names.dart';
import '../../../initialize.dart';
import '../interfaces/airport_carts_data_source_interface.dart';

const String userJsonLocalKey = "UserJson";

class AirportCartsLocalDataSource implements AirportCartsDataSourceInterface {
  final LocalDataSource localDataSource = getIt<LocalDataBase>();
  AirportCartsLocalDataSource();

  @override
  Future<AirportGetCartsResponse> airportGetCarts({required AirportGetCartsRequest request}) {
    // TODO: implement airportGetCarts
    throw UnimplementedError();
  }



}
