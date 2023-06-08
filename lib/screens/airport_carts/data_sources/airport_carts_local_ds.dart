import 'dart:developer';
import 'package:brs_panel/screens/airport_carts/usecase/airline_add_uld_usecase.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airline_delete_uld_usecase.dart';
import 'package:brs_panel/screens/airport_carts/usecase/airline_update_uld_usecase.dart';
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

  @override
  Future<AirportAddCartResponse> airportAddCart({required AirportAddCartRequest request}) {
    // TODO: implement airportAddCart
    throw UnimplementedError();
  }

  @override
  Future<AirportDeleteCartResponse> airportDeleteCart({required AirportDeleteCartRequest request}) {
    // TODO: implement airportDeleteCart
    throw UnimplementedError();
  }

  @override
  Future<AirportUpdateCartResponse> airportUpdateCart({required AirportUpdateCartRequest request}) {
    // TODO: implement airportUpdateCart
    throw UnimplementedError();
  }



}
